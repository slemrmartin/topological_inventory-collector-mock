require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerTemplate < Entity
        def to_hash
          shared_attributes.merge(
            :container_project_name => link_to(:container_projects, :ref => :name)
          )
        end
      end
    end
  end
end
