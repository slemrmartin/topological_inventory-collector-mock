require "openshift/collector"
require "mock_collector/openshift/server"

module MockCollector
  module Openshift
    class Collector < ::Openshift::Collector
      def initialize(source, config: nil, batch_size: 1_000)
        @config_type = config
        super(source, nil, nil, :batch_size => batch_size)
      end

      def connection
        @connection ||= MockCollector::Openshift::Server.new(@config_type)
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
