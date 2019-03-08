require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ServicePlan < Entity
        def to_hash
          shared_attributes.merge(
            :description                 => 'In OpenShift, ServicePlan is ClusterServicePlan',
            :create_json_schema          => create_json_schema,
            :service_offering_source_ref => link_to(:service_offerings)
          )
        end

        def create_json_schema
          {
            :schema => 'http://data-driven-forms.surge.sh/renderer/form-schemas',
            :todo   => true
          }
        end
      end
    end
  end
end
