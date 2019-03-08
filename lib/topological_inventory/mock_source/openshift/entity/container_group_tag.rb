require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerGroupTag < Entity
        def to_hash
          shared_tag_attributes.merge(
            :container_group_source_ref => link_to(:container_groups)
          )
        end
      end
    end
  end
end
