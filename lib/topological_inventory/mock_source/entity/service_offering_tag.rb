require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ServiceOfferingTag < Entity
      def references_hash
        shared_tag_references.merge(
          :service_offering => {:source_ref => link_to(:service_offerings)}
        )
      end
    end
  end
end
