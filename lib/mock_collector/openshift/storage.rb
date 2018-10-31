require "mock_collector/storage"

require "mock_collector/openshift/entity/namespace"
require "mock_collector/openshift/entity/pod"
require "mock_collector/openshift/entity/node"
require "mock_collector/openshift/entity/template"
require "mock_collector/openshift/entity/cluster_service_class"
require "mock_collector/openshift/entity/cluster_service_plan"
require "mock_collector/openshift/entity/service_instance"

module MockCollector
  class Openshift::Storage < Storage
    def entity_types
      %i(namespaces
         pods
         nodes
         templates
         cluster_service_classes
         cluster_service_plans
         service_instances)
    end
  end
end
