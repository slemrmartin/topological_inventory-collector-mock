require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerProjectTag < Entity
        def to_hash
          shared_tag_attributes.merge(
            :container_project_source_ref => link_to(:container_projects)
          )
        end
      end
    end
  end
end
