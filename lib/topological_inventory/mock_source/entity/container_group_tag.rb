require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerGroupTag < Entity
      def references
        shared_tag_references.merge(
          :container_group => {:source_ref => link_to(:container_groups)}
        )
      end
    end
  end
end
