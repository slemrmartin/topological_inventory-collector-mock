require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Pod < Entity
      attr_reader :podIP, :namespace, :nodeName

      # Is NoticeGenerator started for this entity?
      def self.watch_enabled?
        true
      end

      def initialize(_id, _server)
        super

        @podIP    = "127.0.0.1"
        @namespace = link_to(:namespaces, :ref => :name)
        @nodeName = link_to(:nodes, :ref => :name)
      end

      def status
        self
      end

      def spec
        self
      end
    end
  end
end
