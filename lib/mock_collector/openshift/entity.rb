require "mock_collector/entity"

module MockCollector
  module Openshift
    class Entity < ::MockCollector::Entity
      attr_reader :namespace
      def initialize(_id, _entity_type)
        super
        @namespace = link_to(:namespaces, :ref => :name)
      end

      def metadata
        self
      end
    end
  end
end
