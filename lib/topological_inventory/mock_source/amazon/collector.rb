require "topological_inventory/mock_source/collector"
require "topological_inventory/mock_source/amazon/parser"
require "topological_inventory/mock_source/amazon/server"

module TopologicalInventory
  module MockSource
    module Amazon
      class Collector < ::TopologicalInventory::MockSource::Collector
        def path_to_config
          File.expand_path("../../../../config/amazon", File.dirname(__FILE__))
        end

        def connection
          @connection ||= TopologicalInventory::MockSource::Amazon::Server.new
        end

        def collector_thread(_connection, entity_type)
          full_refresh(entity_type)
        rescue => err
          logger.error(err)
        end

        def full_refresh(entity_type)
          (::Settings.full_refresh&.repeats_count || 1).to_i.times do |cnt|
            resource_version = continue = nil

            refresh_state_uuid = SecureRandom.uuid
            logger.info("[#{cnt}] Collecting #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...")

            total_parts = 0
            loop do
              entities = connection.send("get_#{entity_type}", :limit => limits[entity_type], :continue => continue)
              break if entities.nil?

              continue         = entities.continue
              resource_version = entities.resourceVersion

              parser = parser_class.new
              parser.parse_entities(entity_type, entities, storage_class.entity_types[entity_type])

              refresh_state_part_uuid = SecureRandom.uuid
              total_parts += 1
              save_inventory(parser.collections.values, refresh_state_uuid, refresh_state_part_uuid)

              break if entities.last?
            end

            logger.info("[#{cnt}] Collecting #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete - Parts [#{total_parts}]")

            full_refresh_sweep(cnt, entity_type, refresh_state_uuid, resource_version, total_parts)
          end
        rescue => e
          logger.error("Error collecting :#{entity_type}, message => #{e.message}")
          raise e
        end

        def entity_types
          types = storage_class.entity_types.keys
          case ::Settings.full_refresh.send_order
          when :normal then types
          when :reversed then types.reverse
          else
            raise "Send order :#{::Settings.send_order} of entity types unknown. Allowed values: :normal, :reversed"
          end
          types
        end

        def parser_class
          TopologicalInventory::MockSource::Amazon::Parser
        end

        def storage_class
          TopologicalInventory::MockSource::Amazon::Storage
        end

        private

        def full_refresh_sweep(cnt, entity_type, refresh_state_uuid, resource_version, total_parts)
          logger.info("[#{cnt}] Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...")

          parsed_entity_types = [entity_type] + (storage_class.entity_types[entity_type] || []).flatten.compact

          sweep_inventory(refresh_state_uuid,
                          total_parts,
                          parsed_entity_types)

          logger.info("[#{cnt}] Sweeping inactive records for #{entity_type} with :refresh_state_uuid => '#{refresh_state_uuid}'...Complete")
          resource_version
        end
      end
    end
  end
end
