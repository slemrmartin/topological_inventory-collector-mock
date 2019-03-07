require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::VmTag < Entity
        def to_hash
          {
            :tag_name      => "mock-tag-#{@ref_id}",
            :tag_value     => @ref_id.to_s,
            :vm_source_ref => link_to(:vms)
          }
        end
      end
    end
  end
end
