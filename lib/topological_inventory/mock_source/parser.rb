module TopologicalInventory
  module MockSource
    class Parser < TopologicalInventoryIngressApiClient::Collector::Parser
      def parse_entities(entity_type, entities, sub_entity_types = [])
        entities.each { |entity| parse_entity(entity_type, entity, sub_entity_types) }

        collections[entity_type]
      end

      def parse_entity(entity_type, entity, sub_entity_types = [])
        #
        # Type specific parsing if needed
        #
        if respond_to?("parse_#{entity_type.to_s.singularize}")
          send("parse_#{entity_type.to_s.singularize}", entity)
        #
        # Else basic parsing
        #
        else
          parse_entity_simple(entity_type, entity)
          sub_entity_types&.each do |sub_entity_type|
            parse_sub_entity(sub_entity_type, entity)
          end
        end
      end

      def parse_entity_simple(entity_type, entity)
        add_lazy_objects_to(entity)
        object = collections[entity_type].build(entity.data)
        add_resource_timestamp(object)
        object
      end

      protected

      def parse_sub_entity(entity_type, parent_entity)
        storage = parent_entity.storage

        entity_collection = storage.entities[entity_type]

        parse_entity(entity_type,
                     entity_collection.add_entity)
      end

      def lazy_object_refs
        {}
      end

      def add_lazy_objects_to(entity)
        lazy_refs = lazy_object_refs[entity.kind.to_sym]
        if lazy_refs.present?
          lazy_refs.each_pair do |name, references|
            ref_values = {}
            references.each do |reference|
              # i.e. "service_offering_source_ref"
              ref_values[reference] = entity.data.delete("#{name}_#{reference}".to_sym)
            end

            entity.data[name] = lazy_find(name.to_s.pluralize.to_sym, ref_values)
          end
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
