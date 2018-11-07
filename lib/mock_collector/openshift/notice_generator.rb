require "mock_collector/openshift/notice"

module MockCollector
  module Openshift
    class NoticeGenerator
      def self.start(entity_type, server, &block)
        generator = self.new(entity_type, server)

        generator.start(&block)
      end

      attr_reader :server

      delegate :class_for, :to => :server

      # @param entity_type [MockCollector::EntityType]
      def initialize(entity_type, server)
        @entity_type = entity_type
        @server = server
      end

      def start
        loop do
          yield make_notice

          sleep(5)
        end
      end

      def make_notice
        klass = class_for(:notice)
        klass.new(@entity_type.data.first,
                  klass::OPERATION[:added])
      end
    end
  end
end
