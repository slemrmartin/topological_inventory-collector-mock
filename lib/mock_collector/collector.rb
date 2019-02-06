require "topological_inventory-ingress_api-client"

require "config"
require "concurrent"
require "mock_collector/parser"
require "mock_collector/server"

module MockCollector
  class Collector
    def initialize(source, config)
      unless config.nil?
        ::Config.load_and_set_settings(File.join(path_to_config, "#{config}.yml"))
      end

      self.collector_threads  = Concurrent::Map.new
      self.finished           = Concurrent::AtomicBoolean.new(false)
      self.limits             = Hash.new((::Settings.default_limit || 100).to_i)
      self.log                = Logger.new(STDOUT)
      self.poll_time          = ::Settings.events&.check_interval || 5
      self.queue              = Queue.new
      self.source             = source
    end

    def collect!
      if ::Settings.multithreading == :on
        collect_in_threads!
      else
        collect_sequential!
      end
    end

    # Generating entities in parallel using threads
    def collect_in_threads!
      start_collector_threads

      until finished? do
        notices = []
        notices << queue.pop until queue.empty?

        targeted_refresh(notices) unless notices.empty?

        sleep(poll_time)
      end
    end

    # Generating entities sequentially, useful for debugging
    def collect_sequential!
      log.info("Collecting in sequential mode...")

      if %i(standard full_refresh).include?(::Settings.refresh_mode)
        entity_types.each do |entity_type|
          full_refresh(entity_type)
        end
      end

      # Watching events (targeted refresh)
      entity_type = :pods # now pods only

      if %i(standard events).include?(::Settings.refresh_mode)
        watch(entity_type, nil) do |notice|
          log.info("#{entity_type} #{notice.object.metadata.name} was #{notice.type.downcase}")

          targeted_refresh([notice])
        end
      end
    rescue => err
      log.error(err)
    end

    def stop
      finished.value = true
    end

    private

    attr_accessor :collector_threads, :finished, :limits, :log,
                  :poll_time, :queue, :source

    def path_to_config
      File.expand_path("../../config", File.dirname(__FILE__))
    end

    def finished?
      some_thread_alive = entity_types.any? do |entity_type|
        collector_threads[entity_type] && collector_threads[entity_type].alive?
      end

      !some_thread_alive
    end

    def ensure_collector_threads
      entity_types.each do |entity_type|
        next if collector_threads[entity_type] && collector_threads[entity_type].alive?

        collector_threads[entity_type] = start_collector_thread(entity_type)
      end
    end

    alias start_collector_threads ensure_collector_threads

    def start_collector_thread(entity_type)
      log.info("Starting collector thread for #{entity_type}...")

      Thread.new do
        collector_thread(entity_type)
      end
    rescue => err
      log.error(err)
      nil
    end

    def collector_thread(entity_type)
      resource_version = full_refresh(entity_type)

      watch(entity_type, resource_version) do |notice|
        log.info("#{entity_type} #{notice.object.metadata.name} was #{notice.type.downcase}")
        queue.push(notice)
      end
    rescue => err
      log.error(err)
    end

    def watch(entity_type, _resource_version, &block)
      connection.watch(entity_type, &block)
    end

    def full_refresh(entity_type)
      resource_version = continue = nil

      refresh_state_uuid = SecureRandom.uuid
      log.info("Collecting #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...")

      total_parts = 0
      loop do
        entities = connection.send("get_#{entity_type}", :limit => limits[entity_type], :continue => continue)
        break if entities.nil?

        continue         = entities.continue
        resource_version = entities.resourceVersion

        parser = parser_class.new
        parser.send("parse_#{entity_type}", entities)

        refresh_state_part_uuid = SecureRandom.uuid
        total_parts            += 1
        save_inventory(parser.collections.values, refresh_state_uuid, refresh_state_part_uuid)

        break if entities.last?
      end

      log.info("Collecting #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete - Parts [#{total_parts}]")

      log.info("Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...")

      parser     = parser_class.new
      collection = parser.send("parse_#{entity_type}", [])

      sweep_inventory(refresh_state_uuid, total_parts, [collection.name])

      log.info("Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete")
      resource_version
    rescue => e
      log.error("Error collecting :#{entity_type}, message => #{e.message}")
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

    def save_inventory(collections, refresh_state_uuid = nil, refresh_state_part_uuid = nil)
      return if collections.empty?

      ingress_api_client.save_inventory(
        :inventory => TopologicalInventoryIngressApiClient::Inventory.new(
          :name                    => "OCP",
          :schema                  => TopologicalInventoryIngressApiClient::Schema.new(:name => "Default"),
          :source                  => source,
          :collections             => collections,
          :refresh_state_uuid      => refresh_state_uuid,
          :refresh_state_part_uuid => refresh_state_part_uuid,
        )
      )
    end

    def sweep_inventory(refresh_state_uuid, total_parts, sweep_scope)
      ingress_api_client.save_inventory(
        :inventory => TopologicalInventoryIngressApiClient::Inventory.new(
          :name               => "OCP",
          :schema             => TopologicalInventoryIngressApiClient::Schema.new(:name => "Default"),
          :source             => source,
          :collections        => [],
          :refresh_state_uuid => refresh_state_uuid,
          :total_parts        => total_parts,
          :sweep_scope        => sweep_scope,
        )
      )
    end

    # Should be overriden by subclass
    def entity_types
      []
    end

    def ingress_api_client
      TopologicalInventoryIngressApiClient::DefaultApi.new
    end

    def parser_class
      MockCollector::Parser
    end
  end
end
