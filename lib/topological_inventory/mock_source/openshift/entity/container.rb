require "topological_inventory/mock_source/openshift/entity"

module TopologicalInventory
  module MockSource
    module Openshift
      class Entity::Container < Entity
        attr_reader :resources, :image

        def self.resources
          @@resources ||= RecursiveOpenStruct.new(
            :limits   => {
              :cpu    => "2",
              :memory => "256"
            },
            :requests => {
              :cpu    => "1",
              :memory => "128"
            }
          )
        end

        def initialize(_id, _entity_type)
          super

          @resources = self.class.resources
          @image     = link_to(:images)
        end
      end
    end
  end
end
