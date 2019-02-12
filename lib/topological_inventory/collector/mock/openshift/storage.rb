require "topological_inventory/collector/mock/storage"

require "topological_inventory/collector/mock/openshift/entity/namespace"
require "topological_inventory/collector/mock/openshift/entity/container"
require "topological_inventory/collector/mock/openshift/entity/pod"
require "topological_inventory/collector/mock/openshift/entity/node"
require "topological_inventory/collector/mock/openshift/entity/template"
require "topological_inventory/collector/mock/openshift/entity/image"
require "topological_inventory/collector/mock/openshift/entity/cluster_service_class"
require "topological_inventory/collector/mock/openshift/entity/cluster_service_plan"
require "topological_inventory/collector/mock/openshift/entity/service_instance"

module TopologicalInventory
  module Collector
    module Mock
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
end
