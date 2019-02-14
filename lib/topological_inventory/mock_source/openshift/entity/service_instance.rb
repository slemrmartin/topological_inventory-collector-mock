require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ServiceInstance < Entity
        attr_reader :spec

        def initialize(_id, _entity_type)
          super
          @spec = RecursiveOpenStruct.new(
            :externalName           => @name,
            :externalID             => @uid,
            :clusterServicePlanRef  => {
              :name => link_to(:cluster_service_plans)
            },
            :clusterServiceClassRef => {
              :name => link_to(:cluster_service_classes)
            }
          )
        end
      end
    end
  end
end
