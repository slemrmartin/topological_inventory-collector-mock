require "mock_collector/entity"

module MockCollector
  module Openshift
    class Entity < ::MockCollector::Entity
      attr_reader :namespace
      def initialize(_id, _entity_type)
        super
        @namespace = 'namespace-name' #TODO
      end

      def metadata
        self
      end
    end
  end
end
