require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::ServiceOfferingTag < Entity
        def to_hash
          {
            :tag_name                    => "mock-tag-#{@ref_id}",
            :tag_value                   => @ref_id.to_s,
            :service_offering_source_ref => link_to(:service_offerings)
          }
        end
      end
    end
  end
end
