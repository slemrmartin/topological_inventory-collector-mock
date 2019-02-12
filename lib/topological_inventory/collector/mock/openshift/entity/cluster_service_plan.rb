require "topological_inventory/collector/mock/openshift/entity"
require "kubeclient/resource"

module TopologicalInventory
  module Collector
    module Mock
      module Openshift
        class Entity::ClusterServicePlan < Entity
          attr_reader :spec

          def initialize(_id, _entity_type)
            super
            @spec = RecursiveOpenStruct.new(
              :externalName                  => @name,
              :externalID                    => @uid,
              :description                   => 'Cluster Service Plan',
              :instanceCreateParameterSchema => ::Kubeclient::Resource.new(:type => "object", :"$schema" => "http://json-schema.org/draft-04/schema", :additionalProperties => false),
              :clusterServiceClassRef        => {
                :name => link_to(:cluster_service_classes)
              }
            )
          end
        end
      end
    end
  end
end
