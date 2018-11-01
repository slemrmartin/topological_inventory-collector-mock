module MockCollector
  class EntityType
    include Enumerable

    attr_reader :storage, :config, :data, :ref_id, :name

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

    def each
      @data.each do |entity|
        yield entity
      end
    end

    def <<(entity)
      @refs << entity.reference
      @data << entity
    end
    alias push <<

    def resourceVersion
      "1"
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

    def link(entity_id, dest_entity_type)
      if @config.object_counts[dest_entity_type].to_i == 0
        # TODO: can be nil in the future
        raise "Nil config on #{dest_entity_type}"
      end

      dest_entity_id = entity_id % @config.object_counts[dest_entity_type]

      @storage.entities[dest_entity_type].uid_for(dest_entity_id)
    end

    def uid_for(entity_id)
      case config.uuid_strategy
      when :random_uuids then SecureRandom.uuid
      when :sequence_uuids then sequence_uuid(entity_id)
      when :human_uid then human_uid(entity_id)
      else raise "Unknown UUID generating strategy: #{config.uuid_strategy}. Choose from (:random_uuids, :sequence_uuids)"
      end
    end

    private

    def sequence_uuid(entity_id)
      collector_id   = "%08x" % storage.ref_id
      entity_type_id = "%04x" % @ref_id
      ref_id         = "%020x" % entity_id

      "#{collector_id}-#{entity_type_id}-#{ref_id[0..3]}-#{ref_id[4..7]}-#{ref_id[8..19]}"
    end

    def human_uid(entity_id)
      "#{storage.collector_type}-#{@name}-#{'%10d' % entity_id}"
    end
  end
end
