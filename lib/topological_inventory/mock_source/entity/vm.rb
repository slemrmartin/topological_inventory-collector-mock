require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::Vm < Entity
      def to_hash
        {
          :source_ref    => @uid,
          :name          => @name,
          :uid_ems       => @uid,
          :power_state   => %w[on off].sample,
          :mac_addresses => [],
        }
      end

      def references_hash
        {
          :flavor => {:source_ref => link_to(:flavors)}
        }
      end
    end
  end
end
