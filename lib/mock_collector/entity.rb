module MockCollector
  class Entity
    attr_reader :entity_type

    attr_reader :name, :uid, :resourceVersion,
                :creationTimestamp, :deletionTimestamp

    delegate :config ,:to => :entity_type

    # @param id [Integer]
    # @param entity_type [MockCollector::EntityType]
    def initialize(id, entity_type)
      @ref_id = id
      @entity_type = entity_type

      @name = generate_name
      @uid  = generate_uid

      @resourceVersion   = "1"
      @creationTimestamp = Time.now.utc
      @deletionTimestamp = nil
    end

    def reference
      @uid
    end

    protected

    def generate_name
      name = self.class.name.to_s.split("::").last
      "mock-#{name.downcase}-#{@ref_id}"
    end

    def generate_uid
      case config.uuid_strategy
      when :random_uuids then SecureRandom.uuid
      when :sequence_uuids then sequence_uuid
      else raise "Unknown UUID generating strategy: #{config.uuid_strategy}. Choose from (:random_uuids, :sequence_uuids)"
      end
    end

    private

    def sequence_uuid
      collector_id   = "%08x" % @entity_type.storage.ref_id
      entity_type_id = "%04x" % @entity_type.ref_id
      ref_id         = "%020x" % @ref_id

      "#{collector_id}-#{entity_type_id}-#{ref_id[0..3]}-#{ref_id[4..7]}-#{ref_id[8..19]}"
    end
  end
end
