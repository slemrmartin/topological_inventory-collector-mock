require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ServiceOffering < Entity
      def to_hash
        {
          :name              => @name,
          :source_ref        => @uid,
          :source_created_at => @created_at,
          :description       => 'Description for Service Offering',
          :display_name      => 'Service Offering',
          :documentation_url => "http://example.com/documentation/",
          :long_description  => "Long description of Service Offering",
          :distributor       => 'Red Hat',
          :support_url       => "http://example.com/support/",
        }
      end

      def references_hash
        {
          :service_offering_icon => {:source_ref => link_to(:service_offering_icons)},
          :source_region         => {:source_ref => link_to(:source_regions)}
        }
      end
    end
  end
end
