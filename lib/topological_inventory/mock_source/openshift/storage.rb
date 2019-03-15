require "topological_inventory/mock_source/storage"

require "topological_inventory/mock_source/openshift/entity/container_project"
require "topological_inventory/mock_source/openshift/entity/container_project_tag"
require "topological_inventory/mock_source/openshift/entity/container"
require "topological_inventory/mock_source/openshift/entity/container_group"
require "topological_inventory/mock_source/openshift/entity/container_group_tag"
require "topological_inventory/mock_source/openshift/entity/container_node"
require "topological_inventory/mock_source/openshift/entity/container_node_tag"
require "topological_inventory/mock_source/openshift/entity/container_template"
require "topological_inventory/mock_source/openshift/entity/container_template_tag"
require "topological_inventory/mock_source/openshift/entity/container_image"
require "topological_inventory/mock_source/openshift/entity/container_image_tag"
require "topological_inventory/mock_source/openshift/entity/service_offering"
require "topological_inventory/mock_source/openshift/entity/service_offering_icon"
require "topological_inventory/mock_source/openshift/entity/service_offering_tag"
require "topological_inventory/mock_source/openshift/entity/service_plan"
require "topological_inventory/mock_source/openshift/entity/service_instance"

module TopologicalInventory
  module MockSource
    class Openshift::Storage < Storage
      # Ordering of items in array is important!
      # Used for ordered generation of entities
      def self.entity_types
        {
          :container_images       => %i[container_image_tags],
          :container_groups       => %i[containers
                                        container_group_tags],
          :container_projects     => %i[container_project_tags],
          :container_nodes        => %i[container_node_tags],
          :container_templates    => %i[container_template_tags],
          :service_instances      => nil,
          :service_offerings      => %i[service_offering_tags],
          :service_offering_icons => nil,
          :service_plans          => nil
        }
      end
    end
  end
end
