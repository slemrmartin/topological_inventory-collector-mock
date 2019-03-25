require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerProjectTag < Entity
      def references
        shared_tag_references.merge(
          :container_project => {:source_ref => link_to(:container_projects)}
        )
      end
    end
  end
end
