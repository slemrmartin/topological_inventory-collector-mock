require "mock_collector/entity"

module MockCollector
  module Openshift
    class Entity < ::MockCollector::Entity
      attr_reader

      def metadata
        self
      end
    end
  end
end
