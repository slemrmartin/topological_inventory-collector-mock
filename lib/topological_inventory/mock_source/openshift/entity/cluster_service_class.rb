require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::ClusterServiceClass < Entity
        attr_reader :externalID, :externalName, :description, :externalMetadata, :tags

        def initialize(_id, _entity_type)
          super
          @externalName     = @name
          @externalID       = @uid
          @externalMetadata = self.class.external_metadata
          @description      = 'Cluster Service Class'
          @tags             = %w(tag1 tag2 tag3)
        end

        def spec
          self
        end

        def self.external_metadata
          @external_metadata ||= RecursiveOpenStruct.new(
            :displayName         => "Cluster Service Class",
            :documentationUrl    => "http://example.com/documentation/",
            :longDescription     => "This is long description",
            :providerDisplayName => "ClusterServiceClass",
            :supportUrl          => "http://example.com/support/"
          )
        end
      end
    end
  end
end
