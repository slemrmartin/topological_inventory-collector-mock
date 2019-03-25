require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::ServicePlan < Entity
      def to_hash
        shared_attributes.merge(
          :description        => 'In OpenShift, ServicePlan is ClusterServicePlan',
          :create_json_schema => create_json_schema,
        )
      end

      def references
        {
          :service_offering => {:source_ref => link_to(:service_offerings)},
          :source_region    => {:source_ref => link_to(:source_regions)}
        }
      end

      private

      # Data definition for UI forms
      def create_json_schema
        {
          :type        => 'data-driven-forms',
          :description => 'http://data-driven-forms.surge.sh/renderer/form-schemas',
          :schema      => {
            :title       => 'optional',
            :description => 'optional',
            :fields      => [
              # ...
            ]
          }
        }
      end
    end
  end
end
