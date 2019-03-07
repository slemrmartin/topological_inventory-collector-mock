require "topological_inventory/mock_source/amazon/entity"

module TopologicalInventory
  module MockSource
    module Amazon
      class Entity::VolumeType < Entity
        def to_hash
          {
            :source_ref  => @uid,
            :name        => @name,
            :description => 'General Purpose',
            :extra       => {
              :storageMedia  => 'SSD-backed',
              :volumeType    => 'General Purpose',
              :maxIopsvolume => '16000',
              :maxVolumeSize => '16 TiB'
            }
          }
        end
      end
    end
  end
end
