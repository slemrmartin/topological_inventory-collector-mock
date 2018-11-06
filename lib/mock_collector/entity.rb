module MockCollector
  class Entity
    attr_reader :entity_type

    attr_reader :name, :uid, :resourceVersion,
                :creationTimestamp, :deletionTimestamp

    # @param id [Integer]
    # @param entity_type [MockCollector::EntityType]
    def initialize(id, entity_type)
      @ref_id = id
      @entity_type = entity_type

      @name = generate_name
      @uid  = generate_uid

      @resourceVersion   = resource_version
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
      @entity_type.link(@ref_id, dest_entity_type, :ref => ref)
    end

    def resource_version
      case ::Settings.resource_version&.strategy
      when :default_value then resource_version_default_value
      when :timestamp then resource_version_timestamp
      when :ratio then resource_version_by_ratio
      else raise "Unknown resource_version strategy! Allowed values: :default_value, :timestamp, :ratio"
      end
    end

    def resource_version_default_value
      ::Settings.resource_version&.default_value || '1'
    end

    def resource_version_timestamp
      Time.new.to_i
    end

    # Ratio of default values:timestamps for resource version in percents
    def resource_version_by_ratio
      ratio_values = ::Settings.resource_version&.ratio_default_values
      ratio = ratio_values.send(@entity_type.name) unless ratio_values.nil?
      ratio ||= 100

      if ratio == 0 || @ref_id > (@entity_type.entities_total * (ratio / 100.0))
        resource_version_timestamp
      else
        resource_version_default_value
      end
    end
  end
end
