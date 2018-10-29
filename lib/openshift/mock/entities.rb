module Openshift
  module Mock
    class Entities
      include Enumerable

      def initialize
        @entities = []
        @refs = []
      end

      def each
        @entities.each do |entity|
          yield entity
        end
      end

      def resourceVersion
        "1"
      end

      def <<(entity)
        @entities << entity
        @refs << entity.reference
      end
      alias push <<
    end
  end
end
