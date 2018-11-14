require "mock_collector/entity_type"

module MockCollector
  class Server
    def initialize
      @storage = class_for(:storage).new(self)
      @storage.create_entities
    end

    # Collector type for deriving collector-specific class names
    def collector_type
      raise NotImplementedError, "Collector type must be defined in subclass"
    end

    # Classes can be determined from:
    # - collector_type
    # - type
    # @param type [Symbol] :storage | :entity | :entity_type | ...
    def class_for(type)
      klass, found = nil, false

      %W(MockCollector::#{collector_type.to_s.classify}::#{type.to_s.classify}
         MockCollector::#{type.to_s.classify}).each do |class_name|
        klass = class_name.safe_constantize
        found = klass.to_s == class_name
        break if found
      end

      raise "Class #{type} doesn't exist!" unless found
      klass
    end

    def watch(entity_type, &block)
      class_for(:event_generator).start(@storage.entities[entity_type.to_sym], self, &block)
    end

    # Retrieves data from get_ methods in Openshift Collector's parser
    # Watch_ methods not implemented.
    def method_missing(method_name, *arguments, &block)
      # get
      if method_name.to_s.start_with?('get_')
        entity_type = @storage.entities[method_name.to_s.gsub("get_", '').to_sym]
        return nil unless entity_type

        entity_type.prepare_for_pagination(arguments[0][:limit] || 0, arguments[0][:continue] || 0)
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
