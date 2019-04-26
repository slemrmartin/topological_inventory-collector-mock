require "config"
require "concurrent"
require "topological_inventory-ingress_api-client/collector"
require "topological_inventory/mock_source/logging"
require "topological_inventory/mock_source/parser"
require "topological_inventory/mock_source/server"
require "topological_inventory/mock_source/storage"

module TopologicalInventory
  module MockSource
    class Collector < TopologicalInventoryIngressApiClient::Collector
      include Logging

      def initialize(source, config, amounts)
        initialize_config(config, amounts)

        super(source,
              :default_limit => (::Settings.default_limit || 100).to_i,
              :poll_time     => (::Settings.events&.check_interval || 5).to_i)
      end

      def collect!
        loop do
          #
          # Collect each entity type in 1 / separate threads
          #
          if ::Settings.multithreading == :on
            collect_in_threads!
          else
            collect_sequential!
          end

          if ::Settings.refresh_mode == :full_refresh
            sleep_duration = ::Settings.full_refresh&.sleep_duration.to_i
            logger.info("Full refresh finished, sleeping #{sleep_duration} seconds...")
            sleep(sleep_duration)
          else
            break
          end
        end
      end

      def collect_in_threads!
        if %i[standard events].include?(::Settings.refresh_mode)
          super
        else # full_refresh
          start_collector_threads

          # wait for all threads
          sleep(poll_time) until finished?
        end
      end

      # Generating entities sequentially, useful for debugging
      def collect_sequential!
        logger.info("Collecting in sequential mode...")

        if %i[standard full_refresh].include?(::Settings.refresh_mode)
          entity_types.each do |entity_type|
            full_refresh(entity_type)
          end
        end

        # Watching events (targeted refresh)
        entity_type = :container_groups # now pods only

        if %i[standard events].include?(::Settings.refresh_mode)
          watch(entity_type, nil) do |event|
            logger.info("#{entity_type} #{event.object.name} was #{event.type.downcase}")

            targeted_refresh([event])
          end
        end
      rescue => err
        logger.error(err)
      end

      protected

      attr_accessor :collector_threads, :finished, :limits,
                    :poll_time, :queue, :source

      def path_to_amounts_config
        File.expand_path("../../../config/amounts", File.dirname(__FILE__))
      end

      def path_to_defaults_config
        File.expand_path("../../../config", File.dirname(__FILE__))
      end

      def finished?
        some_thread_alive = entity_types.any? do |entity_type|
          collector_threads[entity_type]&.alive?
        end

        !some_thread_alive
      end

      def collector_thread(_connection, entity_type)
        if %i[standard full_refresh].include?(::Settings.refresh_mode)
          resource_version = full_refresh(entity_type)
        end

        # Stop if full refresh only
        return if ::Settings.refresh_mode == :full_refresh

        # Watching events (targeted refresh)
        if %i[standard events].include?(::Settings.refresh_mode)
          watch(entity_type, resource_version) do |event|
            logger.info("#{entity_type} #{event.object.name} was #{event.type.downcase}")
            queue.push(event)
          end
        end
      rescue => err
        logger.error(err)
      end

      def entity_types
        types = requested_entity_types
        case ::Settings.full_refresh.send_order
        when :normal then types
        when :reversed then types.reverse
        else
          raise "Send order :#{::Settings.send_order} of entity types unknown. Allowed values: :normal, :reversed"
        end
        types
      end

      def requested_entity_types
        all_types = storage_class.entity_types.keys
        requested = ::Settings.amounts.keys
        all_types & requested # intersection
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
          resource_version = entities.resource_version

          parser = parser_class.new
          parser.parse_entities(entity_type, entities, storage_class.entity_types[entity_type])
          refresh_state_part_uuid = SecureRandom.uuid
          total_parts             += 1
          save_inventory(parser.collections.values, refresh_state_uuid, refresh_state_part_uuid)

          break if entities.last?
        end

        logger.info("Collecting #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete - Parts [#{total_parts}]")

        full_refresh_sweep(entity_type, refresh_state_uuid, resource_version, total_parts)
      rescue => e
        logger.error("Error collecting :#{entity_type}, message => #{e.message}")
        raise e
      end

      def full_refresh_sweep(entity_type, refresh_state_uuid, resource_version, total_parts)
        logger.info("Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...")

        parsed_entity_types = [entity_type] + (storage_class.entity_types[entity_type] || []).flatten.compact
        # parsed_entity_types = [entity_type]

        sweep_inventory(refresh_state_uuid,
                        total_parts,
                        parsed_entity_types)

        logger.info("Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete")
        resource_version
      end

      def targeted_refresh(events)
        parser = parser_class.new

        events.each do |event|
          parser.parse_event(event)
        end

        save_inventory(parser.collections.values)
      end

      def parser_class
        TopologicalInventory::MockSource::Parser
      end

      def storage_class
        TopologicalInventory::MockSource::Storage
      end

      def connection
        @connection ||= TopologicalInventory::MockSource::Server.new
      end

      def connection_for_entity_type(_entity_type)
        :unused
      end

      def initialize_config(settings_config, amounts_config)
        settings_file = File.join(path_to_defaults_config, "#{sanitize_filename(settings_config)}.yml")
        amounts_file  = File.join(path_to_amounts_config, "#{sanitize_filename(amounts_config)}.yml")

        raise "Settings configuration file #{settings_config} doesn't exist" unless File.exist?(settings_file)
        raise "Amounts configuration file #{amounts_config} doesn't exist" unless File.exist?(amounts_file)

        ::Config.load_and_set_settings(settings_file, amounts_file)
      end

      def sanitize_filename(filename)
        # Remove any character that aren't 0-9, A-Z, or a-z, / or -
        filename.gsub(/[^0-9A-Z\/\-]/i, '_')
      end
    end
  end
end
