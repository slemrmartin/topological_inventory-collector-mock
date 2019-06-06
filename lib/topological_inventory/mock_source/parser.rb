module TopologicalInventory
  module MockSource
    class Parser < TopologicalInventoryIngressApiClient::Collector::Parser
      require "topological_inventory/mock_source/parser/custom_lazy_find"
      require "topological_inventory/mock_source/parser/custom_parsing"
      include TopologicalInventory::MockSource::Parser::CustomLazyFind
      include TopologicalInventory::MockSource::Parser::CustomParsing

      def parse_entities(entity_type, entities, sub_entity_types = [])
        entities.each { |entity| parse_entity(entity_type, entity, sub_entity_types) }

        collections[entity_type]
      end

      def parse_entity(entity_type, entity, sub_entity_types = [])
        #
        # Type specific parsing if needed
        #
        if respond_to?("parse_#{entity_type.to_s.singularize}")
          inventory_object = send("parse_#{entity_type.to_s.singularize}", entity, sub_entity_types)
        #
        # Else basic parsing
        #
        else
          inventory_object = parse_entity_simple(entity_type, entity)
          parse_sub_entities(sub_entity_types, entity)
        end
        inventory_object
      end

      # @param event [TopologicalInventory::MockSource::Event]
      def parse_event(event)
        entity = event.object
        entity_type = entity&.kind&.to_sym
        return if entity.nil? || entity_type.nil?

        sub_entity_types = entity.storage.class.entity_types[entity_type]

        inventory_object = parse_entity(entity_type, entity, sub_entity_types)
        archive_entity(inventory_object, entity) if event.type == "DELETED"
        inventory_object
      end

      def archive_entity(inventory_object, entity)
        source_deleted_at                  = entity.deleted_at || Time.now.utc
        inventory_object.source_deleted_at = source_deleted_at
      end

      def lazy_find(collection, reference, ref: :manager_ref)
        # binding.pry if collection == :container_group_tags
        super unless reference.nil?
      end

      protected

      def parse_entity_simple(entity_type, entity)
        add_lazy_objects_to(entity)
        inventory_object = collections[entity_type].build(entity.data)
        add_resource_timestamp(inventory_object)
        inventory_object
      end

      def parse_sub_entities(sub_entity_types, parent_entity)
        sub_entity_types&.each do |sub_entity_type|
          parse_sub_entity(sub_entity_type, parent_entity)
        end
      end

      def parse_sub_entity(sub_entity_type, parent_entity)
        sub_entities(sub_entity_type, parent_entity) do |sub_entity|
          parse_entity(sub_entity_type,
                       sub_entity)
        end
      end

      def sub_entities(sub_entity_type, parent_entity)
        storage = parent_entity.storage
        sub_collection = storage.entities[sub_entity_type]

        parent_current = parent_entity.ref_id # starts with idx == 0
        parent_total   = parent_entity.entity_type.stats[:total].value
        sub_total = sub_collection.stats[:total].value

        # children per parent (rounded down)
        ratio = sub_total / parent_total
        idx = {}

        # a) more sub_entities than parents
        #    - sub_entities generated in ratio except for last parent
        if ratio > 0
          idx[:start] = ratio * parent_current

          idx[:end] = if sub_total - idx[:start] >= ratio &&
                         parent_current < parent_total - 1
                        idx[:start] + ratio - 1
                      else
                        sub_total - 1
                      end
        # b) less sub_entities than parents
        #    - sub_entities associated 1:1 until available
        else
          idx[:start] = parent_current
          idx[:end]   = parent_current < sub_total ? idx[:start] : -1
        end

        (idx[:start]..idx[:end]).each do |index|
          yield sub_collection.get_entity(index)
        end
      end

      # Adds InventoryLazyObject with ref: :manager_ref to data
      # If custom lazy object needed, define custom parse method
      #
      # @param entity [TopologicalInventory::MockSource::Entity]
      def add_lazy_objects_to(entity)
        entity.references.each_pair do |collection_name, reference|
          entity.data[collection_name] = lazy_find(collection_name.to_s.pluralize.to_sym, reference)
        end
      end

      # @param object [TopologicalInventoryIngressApiClient::<model>]
      def add_resource_timestamp(object)
        return if object.nil?

        if object.respond_to?(:resource_timestamp)
          object.resource_timestamp = @resource_timestamp
        end
        object
      end
    end
  end
end
