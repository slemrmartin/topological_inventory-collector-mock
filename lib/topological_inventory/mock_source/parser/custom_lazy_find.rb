module TopologicalInventory
  module MockSource
    class Parser
      module CustomLazyFind
        def lazy_find_container_project(reference)
          return if reference.nil? || reference[:name].nil?

          lazy_find(:container_projects, reference, :ref => :by_name)
        end

        def lazy_find_container_node(reference)
          return if reference.nil? || reference[:name].nil?

          lazy_find(:container_nodes, reference, :ref => :by_name)
        end
      end
    end
  end
end