require "topological_inventory/mock_source/entity/container_project"
require "topological_inventory/mock_source/entity/container_project_tag"
require "topological_inventory/mock_source/entity/container"
require "topological_inventory/mock_source/entity/container_group"
require "topological_inventory/mock_source/entity/container_group_tag"
require "topological_inventory/mock_source/entity/container_node"
require "topological_inventory/mock_source/entity/container_node_tag"
require "topological_inventory/mock_source/entity/container_template"
require "topological_inventory/mock_source/entity/container_template_tag"
require "topological_inventory/mock_source/entity/container_image"
require "topological_inventory/mock_source/entity/container_image_tag"
require "topological_inventory/mock_source/entity/flavor"
require "topological_inventory/mock_source/entity/service_offering"
require "topological_inventory/mock_source/entity/service_offering_icon"
require "topological_inventory/mock_source/entity/service_offering_tag"
require "topological_inventory/mock_source/entity/service_plan"
require "topological_inventory/mock_source/entity/service_instance"
require "topological_inventory/mock_source/entity/source_region"
require "topological_inventory/mock_source/entity/vm"
require "topological_inventory/mock_source/entity/vm_tag"
require "topological_inventory/mock_source/entity/volume"
require "topological_inventory/mock_source/entity/volume_attachment"
require "topological_inventory/mock_source/entity/volume_type"

module TopologicalInventory
  module MockSource
    class Storage
      attr_reader :entities, :server, :ref_id

      def self.entity_types
        {
          :container_images       => %i[container_image_tags],
          :container_groups       => %i[containers
                                        container_group_tags],
          :container_projects     => %i[container_project_tags],
          :container_nodes        => %i[container_node_tags],
          :container_templates    => %i[container_template_tags],
          :flavors                => nil,
          :service_instances      => nil,
          :service_offerings      => %i[service_offering_tags],
          :service_offering_icons => nil,
          :service_plans          => nil,
          :source_regions         => nil,
          :vms                    => %i[vm_tags],
          :volumes                => %i[volume_attachments],
          :volume_types           => nil
        }
      end

      def initialize(server)
        @server = server

        @entities = {}
        # UUID simulation of entity consists of storage id
        @ref_id = 0
      end

      # Creates entity types and initializes data
      def create_entities
        entity_types.each do |entity_type|
          create_entities_of(entity_type)
        end
      end

      # List of entity types which this server provides
      # Should be defined by subclass
      def entity_types
        self.class.entity_types.flatten.flatten.compact
      end

      # Keys in @entities are method names
      def method_missing(method_name, *arguments, &block)
        if respond_to_missing?(method_name)
          @entities[method_name]
        else
          super
        end
      end

      def respond_to_missing?(method_name, _include_private = false)
        entity_types.include?(method_name.to_sym)
      end

      protected

      def create_entities_of(entity_type)
        amounts = ::Settings.data&.amounts || {}
        initial_amount = amounts[entity_type].to_i

        @entities[entity_type] = TopologicalInventory::MockSource::EntityType.new(entity_type,
                                                                    self,
                                                                    entity_type_ref_id(entity_type),
                                                                    initial_amount)
      end

      def entity_type_ref_id(entity_type)
        entity_types.index(entity_type) || @entities.keys.size + 1 # if index is missing
      end
    end
  end
end
