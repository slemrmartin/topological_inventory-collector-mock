require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerNodeTag < Entity
        def to_hash
          shared_tag_attributes.merge(
            :container_node_source_ref => link_to(:container_nodes)
          )
        end
      end
    end
  end
end
