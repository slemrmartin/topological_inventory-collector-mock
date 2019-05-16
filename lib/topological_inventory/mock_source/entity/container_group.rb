require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerGroup < Entity
      # Is NoticeGenerator started for this entity?
      def self.watch_enabled?
        true
      end

      def to_hash
        shared_attributes.merge(
          :ipaddress => '127.0.0.1',
        )
      end

      def references_hash
        {
          :container_node    => {:name => link_to(:container_nodes, :ref => :name)},
          :container_project => {:name => link_to(:container_projects, :ref => :name)}
        }
      end
    end
  end
end
