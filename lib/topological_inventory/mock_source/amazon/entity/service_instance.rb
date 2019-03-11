require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::ServiceInstance < Entity
        def to_hash
          {
            :source_ref                  => @uid,
            :name                        => @name,
            :source_created_at           => @created_at,
            :service_offering_source_ref => link_to(:service_offerings),
            :service_plan_source_ref     => link_to(:service_plans),
            :source_region_source_ref    => link_to(:source_regions),
            :extra                       => {
              :arn                 => 'arn',
              :type                => 'type',
              :status              => 'status',
              :status_message      => 'status_message',
              :idempotency_token   => 'idempotency_token',
              :last_record_id      => '1',
              :last_record_detail  => 'last_record_detail',
              :last_record_outputs => 'last_record_outputs'
            }
          }
        end
      end
    end
  end
end
