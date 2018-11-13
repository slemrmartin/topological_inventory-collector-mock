# Mock collector for OpenShift
Mock collector for Topological Inventory service

At this moment, it can simulate full refresh in OpenShift.
It's using https://github.com/agrare/openshift-collector.

start collector:
`bin/openshift-mock-collector --source <source> --config <type>`

@param `source` is sources.uid from topological_inventory db
(service https://github.com/ManageIQ/topological_inventory-core)

@param `config` [optional] - YAML files in /config/openshift dir (without ".yml")
 - default (default value)
 - small
 - large

    
Example:
```
bin/openshift-mock-collector --source 31b5338b-685d-4056-ba39-d00b4d7f19cc --config small
```    
_Note: Source is manager for this provider (like ExtManagementSystem in ManageIQ)_
  
---

You can create these local files:
* bundler.d/Gemfile.dev.rb - local gems
* lib/mock_collector/require.dev.rb - local requires
