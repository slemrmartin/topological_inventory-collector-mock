require "topological_inventory/mock_source/entity_type"
require "topological_inventory/mock_source/event_generator"

module TopologicalInventory
  module MockSource
    class Server
      def initialize
        @storage = TopologicalInventory::MockSource::Storage.new(self)
        @storage.create_entities
      end

      def watch(entity_type, &block)
        TopologicalInventory::MockSource::EventGenerator.start(@storage.entities[entity_type.to_sym], self, &block)
      end

      # Retrieves data from get_ methods in Openshift Collector's parser
      # Watch_ methods not implemented.
      def method_missing(method_name, *arguments, &block)
        # get
        if method_name.to_s.start_with?('get_')
          entity_type = @storage.entities[method_name.to_s.gsub("get_", '').to_sym]
          return nil unless entity_type

          args = arguments[0] || {}
          entity_type.prepare_for_pagination(args[:limit] || 0, args[:continue] || 0)
          entity_type
        else
          super
        end
      end

      def respond_to_missing?(method_name, _include_private = false)
        method_name.to_s.start_with?("get_")
      end
    end
  end
end
