#!/usr/bin/env bash

source "config"
source "functions/source_type.sh"
source "functions/source.sh"


# LIST tenants
sources_api_get "tenants" "internal/v1.0"
echo ""
api_get "tenants" "internal/v0.0"
echo ""

# GET Mock-Source Type
#response=`api_get "source_types?filter[name]=mock-source"`
#echo ${response} | jq '.'

# CREATE Mock-Source Type
#api_post "source_types" "{\"name\":\"mock-source\",\"product_name\":\"Mock Source X\",\"vendor\":\"Red Hat\"}"

# GET Sources
#api_get "sources"
#echo " "

# CREATE Source
#api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"

# DELETE Source
#api_delete "sources/1"
#echo " "

# Create/change BuildConfig
#oc process -f openshift/topological-inventory-mock-collector.yaml | oc apply -f -
# Build image
#oc start-build topological-inventory-mock-collector

# Create ConfigMap custom.yml
#oc apply -f openshift/custom-mock-config.yaml

# Deploy pod
#oc process -f openshift/topological-inventory-mock-collector.yaml --param-file="openshift/mock-collector.env" | oc apply -f -
#oc process -f openshift/topological-inventory-mock-collector.yaml \
#           -p CONFIG_NAME="default" \
#           -p AMOUNTS_CONFIG_NAME="custom" \
#           -p SOURCE_ID=${source_id} \
#           | oc apply -f -

# Delete mock pods + deployment config
#oc delete deploymentconfig topological-inventory-mock-collector

## Check it!
#api_get "container_groups"

#
# Create X sources with some config
#
#oc apply -f ${config_file}
#

#echo "Creating Source Type if missing..."
#source_type_id=$(find_or_create_source_type)
#echo "Source Type ID: ${source_type_id}"

#echo "Create Sources"
#cnt=$(sources_count)
#echo $cnt

#delete_all_sources

#create_sources ${source_type_id}

# create_mock_source
# delete_mock_source

# deploy_mock_pod
# delete_mock_pod
sources_api_get 'sources'
echo ""

# Check it!
api_get "container_groups"
echo ""
#records_count $(api_get "container_groups")
