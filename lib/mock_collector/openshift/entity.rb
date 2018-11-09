require "mock_collector/entity"

module MockCollector
  module Openshift
    class Entity < ::MockCollector::Entity
      attr_reader

      # Is NoticeGenerator started for this entity?
      # Can be overriden by subclasses
      def self.watch_enabled?
        false
      end

      def metadata
        self
      end
    end
  end
end
