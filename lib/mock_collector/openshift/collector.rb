require "config"
require "openshift/collector"
require "mock_collector/openshift/server"

module MockCollector
  module Openshift
    class Collector < ::Openshift::Collector
      def initialize(source, config: nil, batch_size: 1_000)
        path_to_config = File.expand_path("../../../config/openshift", File.dirname(__FILE__))
        ::Config.load_and_set_settings(File.join(path_to_config, "#{config}.yml"))

        super(source, nil, nil, :batch_size => batch_size)
      end

      def connection
        @connection ||= MockCollector::Openshift::Server.new
      end

      def connection_for_entity_type(_entity_type = nil)
        connection
      end

      def full_refresh(_connection, _entity_type)
        if ::Settings.refresh_mode == :full
          (::Settings.full_refresh&.repeats_count || 1).to_i.times do
            super
          end
          self.stop
        else
          raise NotImplementedError, "targeted refresh (watches) not implemented yet"
        end
      end

      def watch(_connection, _entity_type, _resource_version)
        nil
      end

      def entity_types
        case ::Settings.full_refresh.send_order
        when :normal then MockCollector::Openshift::Storage.entity_types
        when :reversed then MockCollector::Openshift::Storage.entity_types.reverse
        else raise "Send order :#{::Settings.send_order} of entity types unknown. Allowed values: :normal, :reversed"
        end
      end
    end
  end
end
