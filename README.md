# Mock collector for OpenShift
Mock collector for Topological Inventory service

start collector:
`bin/openshift-mock-collector --source <source> --config <type>`

@param `source` is sources.uid from topological_inventory db
(service https://github.com/ManageIQ/topological_inventory-core)

@param `config` - YAML files in /config/openshift dir
    - small
    - large
    
Note: Source is like ExtManagementSystem in ManageIQ
  