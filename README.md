# Mock collector for OpenShift
Mock collector for Topological Inventory service

At this moment, it can simulate full refresh in OpenShift.
It's using https://github.com/agrare/openshift-collector.

start collector:
`bin/openshift-mock-collector --source <source> --config <type>`

@param `source` is sources.uid from topological_inventory db
(service https://github.com/ManageIQ/topological_inventory-core)

@param `config` - YAML files in /config/openshift dir (without ".yml")
 - small
 - large

    
Note: Source is like ExtManagementSystem in ManageIQ
  