require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Pod < Entity
      attr_reader :podIP, :namespace, :nodeName, :nodeSelector

      # Is NoticeGenerator started for this entity?
      def self.watch_enabled?
        true
      end

      def initialize(id, _entity_type)
        super

        @podIP        = "127.0.0.1"
        # metadata.namespace
        @namespace    = link_to(:namespaces, :ref => :name)
        # spec.nodeName
        @nodeName     = link_to(:nodes, :ref => :name)
        # entity.spec.nodeSelector
        @nodeSelector = {}

        @container = @entity_type.storage.entities[:containers].get_entity(id)
      end

      def containers
        [@container]
      end

      def status
        self
      end

      def entity
        self
      end

      def spec
        self
      end
    end
  end
end
