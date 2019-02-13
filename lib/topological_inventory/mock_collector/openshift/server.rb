require "topological_inventory/mock_collector/server"
require "topological_inventory/mock_collector/openshift/storage"

module TopologicalInventory
  module MockCollector
    class Openshift::Server < Server
      # Collector type for deriving class names
      def collector_type
        :openshift
      end
    end
  end
end
