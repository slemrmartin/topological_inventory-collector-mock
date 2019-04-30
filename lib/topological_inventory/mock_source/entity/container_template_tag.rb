require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerTemplateTag < Entity
      def references_hash
        shared_tag_references.merge(
          :container_template => {:source_ref => link_to(:container_templates)}
        )
      end
    end
  end
end
