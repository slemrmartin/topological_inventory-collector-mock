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

    protected

    def generate_name
      @entity_type.name_for(@ref_id)
    end

    def generate_uid
      @entity_type.uid_for(@ref_id)
    end

    def link_to(dest_entity_type, ref: :uid)
      @entity_type.link(@ref_id, dest_entity_type, ref: ref)
    end
  end
end
