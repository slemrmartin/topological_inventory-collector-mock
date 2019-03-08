require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerTemplateTag < Entity
        def to_hash
          shared_tag_attributes.merge(
            :container_template_source_ref => link_to(:container_templates)
          )
        end
      end
    end
  end
end
