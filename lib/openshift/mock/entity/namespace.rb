require "openshift/mock/entity"

module Openshift
  module Mock
    class Entity::Namespace < Entity
      def initialize(id)
        super
        @name = "mock-namespace-#{id}"
      end

      def reference
        @name
      end
    end
  end
end
