require "active_support/inflector"
require "topological_inventory/mock_source/collector"
require "topological_inventory/mock_source/openshift/parser"
require "topological_inventory/mock_source/openshift/server"

module TopologicalInventory
  module MockSource
    module Openshift
      class Collector < ::TopologicalInventory::MockSource::Collector
        def path_to_amounts_config
          File.expand_path("../../../../config/openshift", File.dirname(__FILE__))
        end

        def connection
          @connection ||= TopologicalInventory::MockSource::Openshift::Server.new
        end

        def parser_class
          TopologicalInventory::MockSource::Openshift::Parser
        end

        def storage_class
          TopologicalInventory::MockSource::Openshift::Storage
        end
      end
    end
  end
end
