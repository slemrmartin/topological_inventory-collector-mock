require "mock_collector/storage"

require "mock_collector/openshift/entity/namespace"
require "mock_collector/openshift/entity/container"
require "mock_collector/openshift/entity/pod"
require "mock_collector/openshift/entity/node"
require "mock_collector/openshift/entity/template"
require "mock_collector/openshift/entity/image"
require "mock_collector/openshift/entity/cluster_service_class"
require "mock_collector/openshift/entity/cluster_service_plan"
require "mock_collector/openshift/entity/service_instance"

module MockCollector
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
