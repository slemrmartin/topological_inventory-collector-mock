require "topological_inventory/mock_source/entity"
require "more_core_extensions/core_ext/string/iec60027_2"
require "more_core_extensions/core_ext/string/decimal_suffix"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity < ::TopologicalInventory::MockSource::Entity
        def data(forced_init: false)
          return @data if !@data.nil? && !forced_init

          @data = to_hash
        end

        def to_hash
          {}
        end

        def shared_attributes
          {
            :name              => @name,
            :source_ref        => @uid,
            :resource_version  => @resource_version,
            :source_created_at => @created_at,
          }
        end

        def shared_tag_attributes
          {
            :tag_name  => "mock-tag-#{@ref_id}",
            :tag_value => @ref_id.to_s,
          }
        end
      end
    end
  end
end
