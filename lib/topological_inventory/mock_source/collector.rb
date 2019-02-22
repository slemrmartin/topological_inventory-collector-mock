require "config"
require "concurrent"
require "topological_inventory-ingress_api-client/collector"
require "topological_inventory/mock_source/parser"
require "topological_inventory/mock_source/server"

module TopologicalInventory
  module MockSource
    class Collector < TopologicalInventory::ProviderCommon::Collector
      def initialize(source, config)
        unless config.nil?
          ::Config.load_and_set_settings(File.join(path_to_config, "#{config}.yml"))
        end

        super(source,
              :default_limit => (::Settings.default_limit || 100).to_i,
              :poll_time     => (::Settings.events&.check_interval || 5).to_i)
      end

      def collect!
        if ::Settings.multithreading == :on
          super
        else
          collect_sequential!
        end
      end

      # Generating entities sequentially, useful for debugging
      def collect_sequential!
        logger.info("Collecting in sequential mode...")

        if %i(standard full_refresh).include?(::Settings.refresh_mode)
          entity_types.each do |entity_type|
            full_refresh(entity_type)
          end
        end

        # Watching events (targeted refresh)
        entity_type = :pods # now pods only

        if %i(standard events).include?(::Settings.refresh_mode)
          watch(entity_type, nil) do |notice|
            logger.info("#{entity_type} #{notice.object.metadata.name} was #{notice.type.downcase}")

            targeted_refresh([notice])
          end
        end
      rescue => err
        logger.error(err)
      end

      def stop
        finished.value = true
      end

      private

      attr_accessor :collector_threads, :finished, :limits,
                    :poll_time, :queue, :source

      def path_to_config
        File.expand_path("../../../config", File.dirname(__FILE__))
      end

      def finished?
        some_thread_alive = entity_types.any? do |entity_type|
          collector_threads[entity_type]&.alive?
        end

        !some_thread_alive
      end

      def collector_thread(_connection, entity_type)
        resource_version = full_refresh(entity_type)

        watch(entity_type, resource_version) do |notice|
          logger.info("#{entity_type} #{notice.object.metadata.name} was #{notice.type.downcase}")
          queue.push(notice)
        end
      rescue => err
        logger.error(err)
      end

      def ensure_collector_threads
        # noop
      end

      def watch(entity_type, _resource_version, &block)
        connection.watch(entity_type, &block)
      end

      def full_refresh(entity_type)
        resource_version = continue = nil

        refresh_state_uuid = SecureRandom.uuid
        logger.info("Collecting #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...")

        total_parts = 0
        loop do
          entities = connection.send("get_#{entity_type}", :limit => limits[entity_type], :continue => continue)
          break if entities.nil?

          continue         = entities.continue
          resource_version = entities.resourceVersion

          parser = parser_class.new
          parser.send("parse_#{entity_type}", entities)

          refresh_state_part_uuid = SecureRandom.uuid
          total_parts             += 1
          save_inventory(parser.collections.values, refresh_state_uuid, refresh_state_part_uuid)

          break if entities.last?
        end

        logger.info("Collecting #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete - Parts [#{total_parts}]")

        logger.info("Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...")

        parser     = parser_class.new
        collection = parser.send("parse_#{entity_type}", [])

        sweep_inventory(refresh_state_uuid, total_parts, [collection.name])

        logger.info("Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete")
        resource_version
      rescue => e
        logger.error("Error collecting :#{entity_type}, message => #{e.message}")
        raise e
      end

      def targeted_refresh(notices)
        parser = parser_class.new

        notices.each do |notice|
          entity_type = notice.object&.kind&.underscore
          next if entity_type.nil?

          parse_method = "parse_#{entity_type}_notice"
          parser.send(parse_method, notice)
        end

        save_inventory(parser.collections.values)
      end

      def parser_class
        TopologicalInventory::MockSource::Parser
      end

      def connection_for_entity_type(_entity_type)
        :unused
      end
    end
  end
end
