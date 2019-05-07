#!/usr/bin/env bash

source "config"
source "functions/source_type.sh"
source "functions/source.sh"
#
# LIST tenants ------------------
#
# sources_api_get "tenants" "internal/v1.0"
# echo ""
# api_get "tenants" "internal/v0.0"
# echo ""
#
# SOURCES --------------------
#
# GET Mock-Source Type
# response=`sources_api_get "source_types?filter[name]=mock-source"`
# echo ${response} | jq '.'
#
# CREATE Mock-Source Type
# api_post "source_types" "{\"name\":\"mock-source\",\"product_name\":\"Mock Source X\",\"vendor\":\"Red Hat\"}"
# echo ""
#
# GET Sources
# sources_api_get 'sources'
# echo ""

# CREATE Source
# sources_api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
# echo ""
#
# DELETE Source
# sources_api_delete "sources/1"
# echo ""
#
# DATA ------------------------
#
# GET CONTAINER GROUPS
# api_get "container_groups"
# echo ""
#
# GET FILTERED CONTAINER GROUPS
# api_get "container_groups?filter\[source_id\]=1"
# echo ""
#
# GET COUNT ONLY
# records_count $(api_get "container_groups")
# echo ""
#
#
# OPENSHIFT RELATED ------------
#
# Create/change BuildConfig
#oc process -f openshift/topological-inventory-mock-collector.yml | oc apply -f -
# Build image
#oc start-build topological-inventory-mock-collector

# Create ConfigMap custom.yml
#oc apply -f openshift/custom-mock-config.yml

# Deploy pod
#oc process -f openshift/topological-inventory-mock-collector.yml --param-file="openshift/mock-collector.env" | oc apply -f -
#oc process -f openshift/topological-inventory-mock-collector.yml \
#           -p CONFIG_NAME="default" \
#           -p AMOUNTS_CONFIG_NAME="custom" \
#           -p SOURCE_ID=${source_id} \
#           | oc apply -f -


