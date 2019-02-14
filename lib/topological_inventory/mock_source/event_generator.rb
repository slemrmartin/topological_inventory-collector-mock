require "topological_inventory/mock_source/event"

module TopologicalInventory
  module MockSource
    class EventGenerator
      DEFAULT_INTERVAL = 1

      # Now only pods are enabled to generate events
      def self.start(entity_type, server, &block)
        return unless entity_type&.watch_enabled?

        generator = new(entity_type, server)

        generator.start(&block)
      end

      attr_reader :server

      delegate :class_for, :to => :server

      # @param entity_type [TopologicalInventory::MockSource::EntityType]
      # @param server [TopologicalInventory::MockSource::Openshift::Server]
      def initialize(entity_type, server)
        @entity_type    = entity_type
        @server         = server
        @check_interval = (::Settings.events&.check_interval || DEFAULT_INTERVAL).to_i
      end

      def start
        checks_count do
          %i(add modify delete).each do |operation|
            create_events(operation) do |event|
              yield event unless event.nil?
            end
          end

          sleep(@check_interval)
        end
      end

      protected

      def checks_count
        cnt = ::Settings.events&.checks_count || :infinite
        if cnt == :infinite
          loop do
            yield
          end
        elsif cnt.to_s.to_i > 0
          cnt.to_s.to_i.times do |_i|
            yield
          end
        end
      end

      def create_events(operation)
        deleted_entities          = @entity_type.stats[:deleted].value
        remaining_active_entities = @entity_type.stats[:total].value - deleted_entities

        events_count = events_per_check(operation)
        if operation == :delete || operation == :modify
          events_count = [events_count, remaining_active_entities].min
        end

        (deleted_entities..deleted_entities + events_count - 1).each do |index|
          entity = case operation
                   when :add then
                     @entity_type.add_entity
                   when :delete then
                     @entity_type.archive_entity
                   when :modify then
                     @entity_type.modify_entity(index)
                   end
          yield make_event(entity, operation) unless entity.nil?
        end
      end

      def make_event(entity, operation)
        klass = class_for(:event)
        # save memory with 1 event per generator
        @event        ||= klass.new
        @event.object = entity
        @event.type   = klass::OPERATIONS[operation]
        @event
      end

      def events_per_check(operation)
        events_per_check = ::Settings.events&.per_check&.send(operation).to_i

        if operation == :add
          events_per_check
        else
          [events_per_check, @entity_type.stats[:total].value].min
        end
      end
    end
  end
end
