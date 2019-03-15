module TopologicalInventory
  module MockSource
    class Parser
      module CustomParsing
        def parse_container_group(entity, sub_entity_types)
          inventory_object = parse_entity_simple(:container_groups, entity)
          parse_sub_entities(sub_entity_types, entity)

          inventory_object.container_node    = lazy_find_container_node(entity.references[:container_node])
          inventory_object.container_project = lazy_find_container_project(entity.references[:container_project])
          inventory_object
        end

        def parse_container_node(entity, sub_entity_types)
          inventory_object = parse_entity_simple(:container_nodes, entity)
          parse_sub_entities(sub_entity_types, entity)

          inventory_object.lives_on = lazy_find(:cross_link_vms, :uid_ems => entity.references[:cross_link_vms])
          inventory_object
        end

        def parse_container_template(entity, sub_entity_types)
          inventory_object = parse_entity_simple(:container_templates, entity)
          parse_sub_entities(sub_entity_types, entity)

          inventory_object.container_project = lazy_find_container_project(entity.references[:container_project])
          inventory_object
        end
      end
    end
  end
end