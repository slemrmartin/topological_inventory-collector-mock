module MockCollector
  module Openshift
    class Notice
      attr_reader :object, :type

      OPERATION = {
        :added    => "ADDED",
        :modified => "MODIFIED",
        :deleted  => "DELETED"
      }.freeze

      # @param entity [MockCollector::Entity]
      # @param type [String] ADDED | MODIFIED | DELETED
      def initialize(entity, type)
        @object = entity
        @type = type
      end
    end
  end
end
