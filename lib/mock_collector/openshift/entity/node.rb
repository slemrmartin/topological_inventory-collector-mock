require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Node < Entity
      attr_reader :status

      def initialize(id, server)
        super

        @status = RecursiveOpenStruct.new(
          :capacity => {
            :cpu    => "2",
            :memory => "100"
          }
        )
      end

      def reference
        @name
      end
    end
  end
end
