require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity < ::TopologicalInventory::MockSource::Entity
        def data(forced_init: false)
          return @data if !@data.nil? && !forced_init

          @data = to_hash
        end

        def to_hash
          {}
        end
      end
    end
  end
end
