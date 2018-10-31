require "mock_collector/configuration"

module MockCollector
  module Openshift
    class Configuration < ::MockCollector::Configuration
      attr_reader :object_counts

      def initialize
        super

        @object_counts = {
          :namespaces              => 3,
          :nodes                   => 2,
          :pods                    => 5,
          :service_instances       => 4,
          :templates               => 6,
          :cluster_service_classes => 2,
          :cluster_service_plans   => 3
        }
      end
    end
  end
end
