module TopologicalInventory
  module MockSource
    class Entity
      attr_reader :entity_type

      attr_reader :name, :uid, :ref_id, :resource_version,
                  :created_at, :deleted_at

      delegate :storage, :to => :entity_type

      # @param id [Integer]
      # @param entity_type [TopologicalInventory::MockSource::EntityType]
      def initialize(id, entity_type)
        @ref_id      = id
        @entity_type = entity_type

        @name = generate_name
        @uid  = generate_uid

        @resource_version = resource_version_by_settings
        @created_at = Time.new(2018, 3, 1).utc
        @deleted_at = nil
      end

      def data(forced_init: false)
        return @data if !@data.nil? && !forced_init

        @data = to_hash
        apply_custom_data
      end

      def references(forced_init: false)
        return @references if !@references.nil? && !forced_init

        @references = references_hash
        apply_custom_references
      end

      def to_hash
        {}
      end

      # openshift entities
      def shared_attributes
        {
          :name              => @name,
          :source_ref        => @uid,
          :resource_version  => @resource_version,
          :source_created_at => @created_at,
        }
      end

      def references_hash
        {}
      end

      def shared_tag_references
        {
          :tag => {
            :name      => "mock-tag-#{@ref_id}",
            :value     => @ref_id.to_s,
            :namespace => 'mock-source' # eq. SourceType.name
          }
        }
      end

      # Can be overriden by subclasses
      def self.watch_enabled?
        false
      end

      def kind
        @entity_type.name.to_s.singularize
      end

      def archive
        @deleted_at = Time.now.utc
      end

      def modify
        @resource_version = resource_version_by_settings
      end

      protected

      # Applies custom data specification from config/data
      def apply_custom_data
        not_overwritable = references_hash.keys
        apply_custom_values do |name, value|
          unless not_overwritable.include?(name.to_sym)
            @data[name.to_sym] = value == 'nil' ? nil : value
          end
        end
        @data
      end

      def apply_custom_references
        not_overwritable = to_hash.keys
        apply_custom_values do |name, value|
          unless not_overwritable.include?(name.to_sym)
            @references[name.to_sym] = value == 'nil' ? nil : value
          end
        end
        @references
      end

      def apply_custom_values
        values = ::Settings.data&.values&.send(@entity_type.name.to_sym)
        if values.present?
          values.each_pair do |name, value|
            val = value.kind_of?(Config::Options) ? value.to_hash : value
            yield name, val
          end
        end
      end

      def generate_name
        @entity_type.name_for(@ref_id)
      end

      def generate_uid
        @entity_type.uid_for(@ref_id)
      end

      def link_to(dest_entity_type, ref: :uid)
        @entity_type.link(@ref_id, dest_entity_type, :ref => ref).to_s
      end

      def resource_version_by_settings
        case ::Settings.resource_version&.strategy
        when :default_value then
          resource_version_default_value
        when :timestamp then
          resource_version_timestamp
        when :ratio then
          resource_version_by_ratio
        else
          raise "Unknown resource_version strategy! Allowed values: :default_value, :timestamp, :ratio"
        end
      end

      def resource_version_default_value
        ::Settings.resource_version_by_settings&.default_value || '1'
      end

      def resource_version_timestamp
        Time.new.to_i.to_s
      end

      # Ratio of default values:timestamps for resource version in percents
      def resource_version_by_ratio
        ratio_values = ::Settings.resource_version_by_settings&.ratio_default_values
        ratio        = ratio_values.send(@entity_type.name) unless ratio_values.nil?
        ratio        = 100 if ratio.nil? || !(0..100).cover?(ratio.to_i)

        if ratio == 0 || @ref_id >= (@entity_type.stats[:total].value * (ratio / 100.0))
          resource_version_timestamp
        else
          resource_version_default_value
        end
      end
    end
  end
end
