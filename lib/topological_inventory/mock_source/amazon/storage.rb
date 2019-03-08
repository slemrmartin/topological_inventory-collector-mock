require "topological_inventory/mock_source/storage"

require "topological_inventory/mock_source/amazon/entity/flavor"
require "topological_inventory/mock_source/amazon/entity/service_instance"
require "topological_inventory/mock_source/amazon/entity/service_offering"
require "topological_inventory/mock_source/amazon/entity/service_offering_tag"
require "topological_inventory/mock_source/amazon/entity/service_plan"
require "topological_inventory/mock_source/amazon/entity/source_region"
require "topological_inventory/mock_source/amazon/entity/vm"
require "topological_inventory/mock_source/amazon/entity/vm_tag"
require "topological_inventory/mock_source/amazon/entity/volume"
require "topological_inventory/mock_source/amazon/entity/volume_attachment"
require "topological_inventory/mock_source/amazon/entity/volume_type"

module TopologicalInventory
  module MockSource
    class Amazon::Storage < Storage
      def self.entity_types
        {
          :flavors           => nil,
          :service_instances => nil,
          :service_offerings => [:service_offering_tags],
          :service_plans     => nil,
          :source_regions    => nil,
          :vms               => [:vm_tags],
          :volumes           => [:volume_attachments],
          :volume_types      => nil
        }
      end
    end
  end
end
