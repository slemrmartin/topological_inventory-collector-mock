require "openshift/collector"
require "mock_collector/openshift/server"

module MockCollector
  module Openshift
    class Collector < ::Openshift::Collector
      def connection
        @connection ||= MockCollector::Openshift::Server.new
      end

      def connection_for_entity_type(_entity_type = nil)
        connection
      end

      def watch(_connection, _entity_type, _resource_version)
        nil
      end
    end
  end
end
