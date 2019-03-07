require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::ServicePlan < Entity
        def to_hash
          {
            :source_ref                  => @uid,
            :name                        => @name,
            :description                 => "Sample Service Plan #{@ref_id}",
            :service_offering_source_ref => link_to(:service_offerings),
            :source_created_at           => @creationTimestamp,
            :create_json_schema          => {:type => 'TODO'},
            :source_region_source_ref    => link_to(:source_regions),
            :extra                       => {
              :artifact                         => 'artifact',
              :launch_path                      => 'launch_path',
              :provisioning_artifact_parameters => 'provisioning_artifact_parameters',
              :constraint_summaries             => 'constraint_summaries',
              :usage_instructions               => 'usage_instructions'
            }
          }
        end
      end
    end
  end
end
