require "active_support/inflector"
require "topological_inventory/mock_source/collector"
require "topological_inventory/mock_source/openshift/parser"
require "topological_inventory/mock_source/openshift/server"

module TopologicalInventory
  module MockSource
    module Openshift
      class Collector < ::TopologicalInventory::MockSource::Collector
        def path_to_config
          File.expand_path("../../../../config/openshift", File.dirname(__FILE__))
        end

        def connection
          @connection ||= TopologicalInventory::MockSource::Openshift::Server.new
        end

        def collector_thread(_connection, entity_type)
          full_refresh(entity_type)

          # Stop if full refresh only
          return if ::Settings.refresh_mode == :full_refresh

          # Watching events (targeted refresh)
          if %i(standard events).include?(::Settings.refresh_mode)
            watch(entity_type, nil) do |notice|
              logger.info("#{entity_type} #{notice.object.metadata.name} was #{notice.type.downcase}")
              queue.push(notice)
            end
          end
        rescue => err
          logger.error(err)
        end

        def full_refresh(entity_type)
          (::Settings.full_refresh&.repeats_count || 1).to_i.times do |cnt|
            logger.info("Collecting #{entity_type}: round #{cnt}")
            super(entity_type)
          end
        end

        def entity_types
          case ::Settings.full_refresh.send_order
          when :normal then
            TopologicalInventory::MockSource::Openshift::Storage.entity_types
            # %i(namespaces)
          when :reversed then
            TopologicalInventory::MockSource::Openshift::Storage.entity_types.reverse
          else
            raise "Send order :#{::Settings.send_order} of entity types unknown. Allowed values: :normal, :reversed"
          end
        end

        def parser_class
          TopologicalInventory::MockSource::Openshift::Parser
        end
      end
    end
  end
end
