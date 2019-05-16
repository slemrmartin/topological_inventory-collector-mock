require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerNodeTag < Entity
      def references_hash
        shared_tag_references.merge(
          :container_node => {:source_ref => link_to(:container_nodes)}
        )
      end
    end
  end
end
