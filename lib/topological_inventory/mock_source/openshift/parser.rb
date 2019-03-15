require "more_core_extensions/core_ext/string/iec60027_2"
require "more_core_extensions/core_ext/string/decimal_suffix"

require "topological_inventory/mock_source/parser"

module TopologicalInventory
  module MockSource
    module Openshift
      class Parser < ::TopologicalInventory::MockSource::Parser
        # All lazy_finds are processed by generic method "parse_entity"
        # (except special ones, see comments below)
        # There has to be reference (uid) in corresponding entity
        #
        # @example:
        # for :container => { :container_group => %i[source_ref] }
        # - :container_group_source_ref key in Entity::Container.to_hash
        #
        def lazy_object_refs
          {
            :container              => {
              :container_group => %i[source_ref],
              :container_image => %i[source_ref]
            },
            # :container_group        => { # parse_container_group method
            #   :container_node    => %i[name],
            #   :container_project => %i[name],
            # },
            :container_group_tag    => {
              :container_group => %i[source_ref],
              :tag             => %i[name value]
            },
            :container_image_tag    => {
              :container_image => %i[source_ref],
              :tag             => %i[name value]
            },
            # :container_node         => { # parse_container_node method
            #   :lives_on => %i[uid_ems]
            # },
            :container_node_tag     => {
              :container_node => %i[source_ref],
              :tag            => %i[name value]
            },
            :container_project_tag  => {
              :container_project => %i[source_ref],
              :tag               => %i[name value]
            },
            # :container_template     => { # parse_container_template method
            #   :container_project => %i[name]
            # },
            :container_template_tag => {
              :container_template => %i[source_ref],
              :tag                => %i[name value]
            },
            :service_instance       => {
              :service_offering => %i[source_ref],
              :service_plan     => %i[source_ref]
            },
            :service_plan           => {
              :service_offering => %i[source_ref]
            },
            :service_offering       => {
              :service_offering_icon => %i[source_ref]
            },
            :service_offering_tag   => {
              :service_offering => %i[source_ref],
              :tag              => %i[name value],
            }
          }
        end

        def parse_event(event)
          entity = event.object
          entity_type = entity&.kind&.to_sym
          return if entity.nil? || entity_type.nil?

          sub_entity_types = entity.storage.class.entity_types[entity_type]

          inventory_object = parse_entity(entity_type, entity, sub_entity_types)
          archive_entity(inventory_object, entity) if event.type == "DELETED"
          inventory_object
        end

        def parse_container_group(entity, sub_entity_types)
          entity.data[:container_node] = lazy_find_container_node(entity.data.delete(:container_node_name))
          entity.data[:container_project] = lazy_find_container_project(entity.data.delete(:container_project_name))

          inventory_object = parse_entity_simple(:container_groups, entity)
          parse_sub_entities(sub_entity_types, entity)
          inventory_object
        end

        def parse_container_node(entity, sub_entity_types)
          entity.data[:lives_on] = lazy_find(:cross_link_vms, :uid_ems => entity.data.delete(:cross_link_vms_uid_ems))

          inventory_object = parse_entity_simple(:container_nodes, entity)
          parse_sub_entities(sub_entity_types, entity)

          inventory_object
        end

        def parse_container_template(entity, sub_entity_types)
          entity.data[:container_project] = lazy_find_container_project(entity.data.delete(:container_project_name))

          inventory_object = parse_entity_simple(:container_templates, entity)
          parse_sub_entities(sub_entity_types, entity)

          inventory_object
        end

        def lazy_find_container_project(name)
          return if name.nil?

          TopologicalInventoryIngressApiClient::InventoryObjectLazy.new(
            :inventory_collection_name => :container_projects,
            :reference                 => {:name => name},
            :ref                       => :by_name,
          )
        end

        def lazy_find_container_node(name)
          return if name.nil?

          TopologicalInventoryIngressApiClient::InventoryObjectLazy.new(
            :inventory_collection_name => :container_nodes,
            :reference                 => {:name => name},
            :ref                       => :by_name,
          )
        end
      end
    end
  end
end
