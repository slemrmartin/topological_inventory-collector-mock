require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::VolumeAttachment < Entity
        def to_hash
          {
            :volume_source_ref => link_to(:volumes),
            :vm_source_ref     => link_to(:vms),
            :device            => '/dev/sda1',
            :state             => volume_attachment_states.sample
          }
        end

        private

        def volume_attachment_states
          %w[attached attaching detaching]
        end
      end
    end
  end
end
