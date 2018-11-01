# Mock collector for OpenShift
Mock collector for Topological Inventory service

start collector:
`bin/openshift-mock-collector --source <source>`

where `source` is sources.uid from topological_inventory db
(service https://github.com/ManageIQ/topological_inventory-core)

Note: Source is like ExtManagementSystem in ManageIQ
  