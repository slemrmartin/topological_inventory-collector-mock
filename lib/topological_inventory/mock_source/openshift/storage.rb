require "topological_inventory/mock_source/storage"

require "topological_inventory/mock_source/openshift/entity/namespace"
require "topological_inventory/mock_source/openshift/entity/container"
require "topological_inventory/mock_source/openshift/entity/pod"
require "topological_inventory/mock_source/openshift/entity/node"
require "topological_inventory/mock_source/openshift/entity/template"
require "topological_inventory/mock_source/openshift/entity/image"
require "topological_inventory/mock_source/openshift/entity/cluster_service_class"
require "topological_inventory/mock_source/openshift/entity/cluster_service_plan"
require "topological_inventory/mock_source/openshift/entity/service_instance"

module TopologicalInventory
  module MockSource
    class Openshift::Storage < Storage
      # Ordering of items in array is important!
      # Used for ordered generation of entities
      def self.entity_types
        %i(namespaces
         nodes
         pods
         templates
         images
         cluster_service_classes
         cluster_service_plans
         service_instances)
      end

      def entity_types
        self.class.entity_types
      end

      # Containers are initialized in a special way by pods
      def create_entities
        create_entities_of(:containers)
        super
      end
    end
  end
end
