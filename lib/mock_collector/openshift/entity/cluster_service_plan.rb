require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::ClusterServicePlan < Entity
      attr_reader :externalID, :externalName, :description, :instanceCreateParameterSchema

      class ClusterServiceClassRef
        def self.name
          "cluster-svc-class-uid"
        end
      end

      def initialize(id, server)
        super
        @externalName = @name
        @externalID   = @uid
        @description  = 'Cluster Service Plan'
        @instanceCreateParameterSchema = ::Kubeclient::Resource.new({"type": "object", "$schema": "http://json-schema.org/draft-04/schema", "additionalProperties": false})
      end

      def spec
        self
      end

      def clusterServiceClassRef
        ClusterServiceClassRef
      end
    end
  end
end
