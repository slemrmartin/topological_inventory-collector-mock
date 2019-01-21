require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Template < Entity
      attr_reader :namespace
      def initialize(_id, _entity_type)
        super
        @namespace = link_to(:namespaces, :ref => :name)
      end
    end
  end
end
