require "config"
require "mock_collector/entity_type"

module MockCollector
  class Server
    # @param config_type [String] - name of config file without .yml suffix.
    #                               Located in config/openshift/
    def initialize(config_type)
      path_to_config = File.expand_path("../../config/#{collector_type.to_s}", File.dirname(__FILE__))
      ::Config.load_and_set_settings(File.join(path_to_config, "#{config_type.to_s}.yml"))

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
    # @param type [Symbol] :storage | :entity | :entity_type
    def class_for(type)
      class_name = "MockCollector::#{collector_type.to_s.classify}::#{type.to_s.classify}"
      klass = class_name.safe_constantize

      raise "Class #{class_name} doesn't exists!" if klass.to_s != class_name
      klass
    end

    # Retrieves data from get_ methods in Openshift Collector's parser
    # Watch_ method not implemented yet.
    def method_missing(method_name, *arguments, &block)
      # get
      if method_name.to_s.start_with?('get_')
        @storage.entities[method_name.to_s.gsub("get_", '').to_sym]
      # watch
      elsif method_name.to_s.start_with?('watch_')
        nil # TODO: Not implemented yet
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      method_name.to_s.start_with?("get_") || method_name.to_s.start_with?("watch_")
    end
  end
end
