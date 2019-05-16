require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::Volume < Entity
      def to_hash
        {
          :source_ref        => @uid,
          :name              => @name,
          :uid_ems           => @uid,
          :power_state       => power_states.sample,
          :source_created_at => @created_at,
          :size              => 2 * 1024**3,
        }
      end

      def references_hash
        {
          :volume_type   => {:source_ref => link_to(:volume_types)},
          :source_region => {:source_ref => link_to(:source_regions)}
        }
      end

      private

      def power_states
        %w[creating available in-use deleting deleted error]
      end
    end
  end
end
