require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Node < Entity
      attr_reader :status, :providerID

      def self.status
        @@status ||= RecursiveOpenStruct.new(
          :capacity => {
            :cpu    => "2",
            :memory => "100"
          }
        )
      end

      def initialize(_id, _entity_type)
        super

        @status = self.class.status
        @providerID = "aws:///us-west-2b/i-02ca66d00f6485e3e"
      end

      def spec
        self
      end
    end
  end
end
