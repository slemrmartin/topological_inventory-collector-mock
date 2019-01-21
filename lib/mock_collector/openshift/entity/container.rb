require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Container < Entity
      attr_reader :resources

      def self.resources
        @@resources ||= RecursiveOpenStruct.new(
          :limits => {
            :cpu    => "2",
            :memory => "256"
          },
          :requests => {
            :cpu => "1",
            :memory => "128"
          }
        )
      end

      def initialize(_id, _entity_type)
        super

        @resources = self.class.resources
      end
    end
  end
end
