require "topological_inventory/mock_source/collector"
require "topological_inventory/mock_source/amazon/parser"
require "topological_inventory/mock_source/amazon/server"

module TopologicalInventory
  module MockSource
    module Amazon
      class Collector < ::TopologicalInventory::MockSource::Collector
        def path_to_amounts_config
          File.expand_path("../../../../config/amazon", File.dirname(__FILE__))
        end

        def connection
          @connection ||= TopologicalInventory::MockSource::Amazon::Server.new
        end

        private

        def collector_thread(_connection, entity_type)
          full_refresh(entity_type)
        rescue => err
          logger.error(err)
        end

        def parser_class
          TopologicalInventory::MockSource::Amazon::Parser
        end

        def storage_class
          TopologicalInventory::MockSource::Amazon::Storage
        end
      end
    end
  end
end
