require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::ClusterServiceClass < Entity
      attr_reader :externalID, :externalName, :description

      def initialize(id, server)
        super
        @externalName = @name
        @externalID   = @uid
        @description  = 'Cluster Service Class'
      end

      def spec
        self
      end
    end
  end
end
