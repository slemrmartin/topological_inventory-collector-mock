require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerImageTag < Entity
      def references
        shared_tag_references.merge(
          :container_image => {:source_ref => link_to(:container_images)}
        )
      end
    end
  end
end
