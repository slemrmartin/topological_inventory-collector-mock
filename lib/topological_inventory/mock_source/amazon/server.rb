require "topological_inventory/mock_source/server"
require "topological_inventory/mock_source/amazon/storage"

module TopologicalInventory
  module MockSource
    class Amazon::Server < Server
      # Collector type for deriving class names
      def collector_type
        :amazon
      end
    end
  end
end
