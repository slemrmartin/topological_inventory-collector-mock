require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::SourceRegion < Entity
        def to_hash
          {
            :source_ref => @uid,
            :name       => @name,
            :endpoint   => "endpoint#{@ref_id}.foo.redhat.com"
          }
        end
      end
    end
  end
end
