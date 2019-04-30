require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ServiceInstance < Entity
      attr_reader :spec

      def to_hash
        {
          :source_ref        => @uid,
          :name              => @name,
          :source_created_at => @created_at,
        }
      end

      def references_hash
        {
          :service_plan     => {:source_ref => link_to(:service_plans)},
          :service_offering => {:source_ref => link_to(:service_offerings)},
          :source_region    => {:source_ref => link_to(:source_regions)}
        }
      end
    end
  end
end
