require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ServiceInstance < Entity
        attr_reader :spec

        def to_hash
          {
            :source_ref                  => @uid,
            :name                        => @name,
            :source_created_at           => @created_at,
            :service_plan_source_ref     => link_to(:service_plans),
            :service_offering_source_ref => link_to(:service_offerings)
          }
        end
      end
    end
  end
end
