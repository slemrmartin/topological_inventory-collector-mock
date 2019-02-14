require "topological_inventory/mock_source/server"
require "topological_inventory/mock_source/openshift/storage"

module TopologicalInventory
  module MockSource
    class Openshift::Server < Server
      # Collector type for deriving class names
      def collector_type
        :openshift
      end
    end
  end
end
