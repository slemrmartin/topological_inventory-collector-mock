require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::Container < Entity
        def to_hash
          {
            :name                       => @name,
            :cpu_limit                  => [nil, 0.1].sample,
            :cpu_request                => [nil, 0.5].sample,
            :memory_limit               => [nil, 100_000_000].sample,
            :memory_request             => [nil, 100_000_000].sample,
            :container_group_source_ref => link_to(:container_groups),
            :container_image_source_ref => link_to(:container_images)
          }
        end
      end
    end
  end
end
