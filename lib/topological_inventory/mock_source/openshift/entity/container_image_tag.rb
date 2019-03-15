require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerImageTag < Entity
        def to_hash
          shared_tag_attributes.merge(
            :container_image_source_ref => link_to(:container_images)
          )
        end
      end
    end
  end
end
