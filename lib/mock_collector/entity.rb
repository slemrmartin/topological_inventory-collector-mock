module MockCollector
  class Entity
    attr_reader :entity_type

    attr_reader :name, :uid, :resourceVersion,
                :creationTimestamp, :deletionTimestamp

    delegate :config ,:to => :entity_type

    # @param id [Integer]
    # @param entity_type [MockCollector::EntityType]
    def initialize(id, entity_type)
      @internal_id = id
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
      "mock-#{name.downcase}-#{@internal_id}"
    end

    def generate_uid
      case config.uuid_strategy
      when :random_uuids then SecureRandom.uuid
      when :sequence_uuids then "2d931510-d99f-494a-8c67-87feb05e1594" #TODO
      else raise "Unknown UUID generating strategy: #{config.uuid_strategy}. Choose from (:random_uuids, :sequence_uuids)"
      end
    end
  end
end
