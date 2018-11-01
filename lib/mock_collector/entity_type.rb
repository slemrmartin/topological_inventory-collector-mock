module MockCollector
  class EntityType
    include Enumerable

    attr_reader :storage, :config, :data, :ref_id

    delegate :collector_type,
             :class_for, :to => :storage

    # @param name [Symbol] identifier in storage
    # @param storage [MockCollector::Storage]
    # @param ref_id [Integer] specific part for uuids of
    #                         all entities of this type
    def initialize(name, storage, ref_id)
      @name = name
      @storage = storage
      @ref_id = ref_id

      @config  = class_for(:configuration).instance

      @data = []
      @refs = []
    end

    def create_data
      @config.object_counts[@name.to_sym].to_i.times do |i|
        @data << entity_class.new(i, self)
      end
    end

    def entity_class
      return @entity_class unless @entity_class.nil?

      class_name = "MockCollector::#{collector_type.to_s.classify}::Entity::#{@name.to_s.classify}"
      klass = class_name.safe_constantize

      raise "Entity class #{class_name} doesn't exists!" if klass.to_s != class_name
      @entity_class = klass
    end

    def each
      @data.each do |entity|
        yield entity
      end
    end

    def resourceVersion
      "1"
    end

    def <<(entity)
      @refs << entity.reference
      @data << entity
    end

    alias push <<
  end
end
