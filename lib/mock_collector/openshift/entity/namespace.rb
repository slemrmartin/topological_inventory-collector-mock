require "mock_collector/openshift/entity"

module MockCollector
  module Openshift
    class Entity::Namespace < Entity
      def reference
        @name
      end
    end
  end
end
