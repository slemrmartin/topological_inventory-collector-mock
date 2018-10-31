require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::ServiceInstance < Entity
      attr_reader :externalID, :externalName

      class ClusterServiceClassRef
        def self.name
          "cluster-svc-class-uid"
        end
      end

      class ClusterServicePlanRef
        def self.name
          "cluster-svc-plan-uid"
        end
      end

      def initialize(id, server)
        super
        @externalName = 'mock_collector-service-instance'
        @externalID  = 'service-instance-uid'
      end

      def spec
        self
      end

      def clusterServiceClassRef
        ClusterServiceClassRef
      end

      def clusterServicePlanRef
        ClusterServicePlanRef
      end
    end
  end
end
