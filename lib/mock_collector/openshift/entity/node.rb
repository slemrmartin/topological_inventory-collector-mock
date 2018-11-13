require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Node < Entity
      attr_reader :status

      def self.status
        @@status ||= RecursiveOpenStruct.new(
          :capacity => {
            :cpu    => "2",
            :memory => "100"
          }
        )
      end

      def initialize(_id, _server)
        super

        @status = self.class.status
      end
    end
  end
end
