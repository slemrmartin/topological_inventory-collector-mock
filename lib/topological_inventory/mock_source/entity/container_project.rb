require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerProject < Entity
      def to_hash
        shared_attributes.merge(
          :display_name => "Namespace #{@ref_id}"
        )
      end
    end
  end
end
