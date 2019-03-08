require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerNode < Entity
        # TODO: vms entity not initialized!
        def to_hash
          shared_attributes.merge(
            :cpus                   => 48,
            :memory                 => 134_902_530_048,
            :cross_link_vms_uid_ems => nil # TODO: link_to(:vms)
          )
        end
      end
    end
  end
end
