module MockCollector
  class Storage
    attr_reader :entities, :server

    delegate :collector_type,
             :class_for, :to => :server

    REF_IDS = {
      :default   => 0,
      :amazon    => 1,
      :azure     => 2,
      :openshift => 4,
    }.freeze

    def initialize(server)
      @server = server

      @entities = {}
      # UUID of entity consists of storage id
      @ref_id   = REF_IDS[collector_type]
    end

    def create_entities
      entity_types.each do |entity_type|
        create_entities_of(entity_type)
      end

      entity_types.each do |entity_type|
        link_entities_of(entity_type)
      end
    end

    # List of entity types which this server provides
    def entity_types
      %i()
    end

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
      # TODO: entity_type provider-specific?
      # @entities[entity_type] = server.class_for(:entity_type).new(entity_type, self, entity_type_ref_id(entity_type))
      @entities[entity_type] = MockCollector::EntityType.new(entity_type, self, entity_type_ref_id(entity_type))

      @entities[entity_type].create_data

      @entities[entity_type].data
    end

    def link_entities_of(entity_type)
      # TODO
    end

    def entity_type_ref_id(entity_type)
      entity_types.index(entity_type)
    end
  end
end
