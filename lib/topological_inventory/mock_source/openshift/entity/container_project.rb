require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerProject < Entity
        def to_hash
          shared_attributes
        end
      end
    end
  end
end
