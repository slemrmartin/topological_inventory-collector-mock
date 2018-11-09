require "mock_collector/openshift/notice"

module MockCollector
  module Openshift
    class NoticeGenerator
      DEFAULT_INTERVAL = 5

      # Now only pods are enabled to generate notices
      def self.start(entity_type, server, &block)
        # return unless entity_type&.watch_enabled?

        generator = self.new(entity_type, server)

        generator.start(&block)
      end

      attr_reader :server

      delegate :class_for, :to => :server

      # @param entity_type [MockCollector::EntityType]
      def initialize(entity_type, server)
        @entity_type = entity_type
        @server = server

        @last_notice = {
          :added    => Time.now.utc,
          :modified => Time.now.utc,
          :deleted  => Time.now.utc
        }
        @check_interval = (::Settings.notices&.check_interval || DEFAULT_INTERVAL).to_i
      end

      def start
        loop do
          %i(added modified deleted).each do |operation|
            create_notices(operation) do |notice|
              yield notice unless notice.nil?
            end
          end

          sleep(@check_interval)
        end
      end

      protected

      def create_notices(operation)
        # binding.pry
        deleted_entities = @entity_type.stats[:deleted].value
        remaining_active_entities = @entity_type.stats[:total].value - deleted_entities

        notices_count = notices_per_check(operation)
        if operation == :deleted || operation == :modified
          notices_count = [notices_count, remaining_active_entities].max
        end

        (deleted_entities..deleted_entities + notices_count - 1).each do |index|
          entity = case operation
                   when :added then @entity_type.add_entity
                   when :deleted then @entity_type.archive_entity
                   when :modified then @entity_type.modify_entity(index)
                   end
          yield make_notice(entity, operation) unless entity.nil?
        end
      end

      def make_notice(entity, operation)
        klass = class_for(:notice)
        # save memory with 1 notice per generator
        @notice ||= klass.new
        @notice.object = entity
        @notice.type = klass::OPERATIONS[operation]
        @notice
      end

      def notices_per_check(operation)
        amount_unit = ::Settings.notices.entities_per_hour_unit
        amount_notices = ::Settings.notices.entities_per_hour.send(operation)

        notices_per_hour = case amount_unit
                           when :fixed_number then amount_notices
                           when :percents then @entity_type.stats[:total].value * amount_notices
                           end
        notices_per_check = (notices_per_hour / 3600.0 * @check_interval).ceil

        [notices_per_check, @entity_type.stats[:total].value].max
      end
    end
  end
end
