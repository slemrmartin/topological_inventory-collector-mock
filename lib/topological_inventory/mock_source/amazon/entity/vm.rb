require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::Vm < Entity
        def to_hash
          {
            :source_ref        => @uid,
            :name              => @name,
            :uid_ems           => @uid,
            :power_state       => %w[on off].sample,
            :mac_addresses     => [],
            :flavor_source_ref => link_to(:flavors)
          }
        end
      end
    end
  end
end
