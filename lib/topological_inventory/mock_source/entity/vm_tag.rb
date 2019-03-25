require "topological_inventory/mock_source/entity"

module TopologicalInventory
  module MockSource
    class Entity::VmTag < Entity
      def references
        shared_tag_references.merge(
          :vm => {:source_ref => link_to(:vms)}
        )
      end
    end
  end
end
