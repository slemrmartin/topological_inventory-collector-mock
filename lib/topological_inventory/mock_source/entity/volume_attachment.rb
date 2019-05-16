require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::VolumeAttachment < Entity
      def to_hash
        {
          :device => '/dev/sda1',
          :state  => volume_attachment_states.sample
        }
      end

      def references_hash
        {
          :volume => {:source_ref => link_to(:volumes)},
          :vm     => {:source_ref => link_to(:vms)},
        }
      end

      private

      def volume_attachment_states
        %w[attached attaching detaching]
      end
    end
  end
end
