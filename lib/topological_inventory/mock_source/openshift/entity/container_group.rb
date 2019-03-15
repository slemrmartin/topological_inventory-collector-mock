require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ContainerGroup < Entity
        # Is NoticeGenerator started for this entity?
        def self.watch_enabled?
          true
        end

        def to_hash
          shared_attributes.merge(
            :ipaddress              => '127.0.0.1',
            :container_node_name    => link_to(:container_nodes, :ref => :name),
            :container_project_name => link_to(:container_projects, :ref => :name)
          )
        end
      end
    end
  end
end
