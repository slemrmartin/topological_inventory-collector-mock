module OpenShift
  module Mock
    class Configuration
      def self.instance
        @configuration ||= self.new
      end

      attr_reader :object_counts

      def initialize
        @object_counts = {
          :namespaces => 3,
          :nodes => 2,
          :pods => 5,
          :service_instances => 4,
          :templates => 6,
          :cluster_service_classes => 2,
          :cluster_service_plans => 3
        }

        # how are associations spread
        @references_strategy = :linear # or :gauss
      end
    end
  end
end