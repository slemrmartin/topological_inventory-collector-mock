# OpenShift deployment for Mock Source

This folder contains all openshift templates and bash scripts needed for deploy 
mock collector with topological-inventory and sources infrastructure. 

## Prerequisites

Script [prerequistes.sh](prerequisities.sh) contains packages needed for these scripts.

## Initial steps

* Login to your openshift using `oc login` command.  
* Create openshift project you want to use and make it current.
* Update your [config file](config):
  * *openshift_project* has to be equal to openshift project name you created.
  * HOST variables will be created later.   


## Build all services

Apply all build configs and secrets running [all-build.sh](all-build.sh).
Then wait when all builds are completed.

## Deploy all services

Deploy all services by [all-deploy.sh](all-deploy.sh).  

*TODO*: it's not tested if deployments needs to wait until previous group is complete (for example api for database).
See the script to know which services are grouped.

## Routes

When deployed, create routes (with default settings) from services.
Through UI, go to 
* **Applications/Services/sources-api**, click on **Create route**
* **Applications/Services/topological-inventory-api**, click on **Create route**

Copy "http://..." values into HOST values in [config file](config)
  
## Mock Source (collector)

### Config

Notice these [config file](config) values:
* source_type_name
  * Name of SourceType created in Sources DB
* config_file
  * Config file will be mapped as "config/custom.yml" files and used as `--config custom` param
* amounts_config_file
  * Data Config file will be mapped as "config/amounts/custom.yml" files and used as `--amounts custom` param
* sources_total
  * How many Sources/deployments/pods will be created. Each source has it's own deployment config with one pod. It's name equals Source.id in db.


### Scripts

* [mock-source-build.sh](mock-source-build.sh): 
  * Builds new image of mock source (for example if source code/gems changes)
* [mock-source-deploy.sh](mock-source-deploy.sh):
  * creates config maps from config files (see config file ^^)
  * creates Source type in sources-postgres
  * creates Source in amount specified by $sources_count in config file
  * (topological-inventory-sync will sync it with topological-postgres)
  * deploys mock-source pod for each Source
* [mock-source-cleanup.sh](mock-source-cleanup.sh):
  * deletes Sources
  * deletes Mock-source pods and deployments
* [examples.sh](examples.sh):
  * see examples, there are helpers how to get data through APIs.
  