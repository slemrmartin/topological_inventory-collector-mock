require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ContainerTemplate < Entity
      def to_hash
        shared_attributes
      end

      def references_hash
        {
          :container_project => {:name => link_to(:container_projects, :ref => :name)}
        }
      end
    end
  end
end
