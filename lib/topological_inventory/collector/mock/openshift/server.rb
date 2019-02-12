require "topological_inventory/collector/mock/server"
require "topological_inventory/collector/mock/openshift/storage"

module TopologicalInventory
  module Collector
    module Mock
      class Openshift::Server < Server
        # Collector type for deriving class names
        def collector_type
          :openshift
        end
      end
    end
  end
end
