require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::Container < Entity
      def to_hash
        {
          :name           => @name,
          :cpu_limit      => [nil, 0.1].sample,
          :cpu_request    => [nil, 0.5].sample,
          :memory_limit   => [nil, 100_000_000].sample,
          :memory_request => [nil, 100_000_000].sample,
        }
      end

      def references
        {
          :container_group => {:source_ref => link_to(:container_groups)},
          :container_image => {:source_ref => link_to(:container_images)}
        }
      end
    end
  end
end
