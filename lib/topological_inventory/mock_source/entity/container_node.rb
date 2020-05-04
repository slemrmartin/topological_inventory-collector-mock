require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerNode < Entity
      def to_hash
        shared_attributes.merge(
          :cpus   => 48,
          :memory => 134_902_530_048,
        )
      end
    end
  end
end
