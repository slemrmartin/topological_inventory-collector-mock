require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerImage < Entity
      def to_hash
        shared_attributes
      end
    end
  end
end
