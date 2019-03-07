require "topological_inventory/mock_source/parser"

module TopologicalInventory
  module MockSource
    module Amazon
      class Parser < ::TopologicalInventory::MockSource::Parser
        def lazy_object_refs
          {
            :service_offering     => {
              :source_region => %i[source_ref],
            },
            :service_instance     => {
              :source_region    => %i[source_ref],
              :service_offering => %i[source_ref],
              :service_plan     => %i[source_ref]

            },
            :service_offering_tag => {
              :service_offering => %i[source_ref],
              :tag              => %i[name value],
            },
            :service_plan         => {
              :service_offering => %i[source_ref],
              :source_region    => %i[source_ref]
            },
            :vm                   => {
              :flavor => %i[source_ref]
            },
            :vm_tag               => {
              :vm  => %i[source_ref],
              :tag => %i[name value]
            },
            :volume               => {
              :volume_type   => %i[source_ref],
              :source_region => %i[source_ref]
            },
            :volume_attachment    => {
              :vm     => %i[source_ref],
              :volume => %i[source_ref]
            }
          }
        end
      end
    end
  end
end
