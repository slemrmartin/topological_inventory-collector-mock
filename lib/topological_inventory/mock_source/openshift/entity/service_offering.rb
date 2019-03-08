require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ServiceOffering < Entity
        def to_hash
          {
            :name                  => @name,
            :source_ref            => @uid,
            :source_created_at     => @creationTimestamp,
            :description           => 'Description for ClusterServiceClass',
            :display_name          => 'Service Offering',
            :documentationUrl      => "http://example.com/documentation/",
            :longDescription       => "In OpenShift, Service Offering is represented by ClusterServiceClass",
            :distributor           => 'Red Hat',
            :supportUrl            => "http://example.com/support/",
            :service_offering_icon => link_to(:service_offering_icons)
          }
        end
      end
    end
  end
end
