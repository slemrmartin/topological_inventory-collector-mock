#!/usr/bin/env bash

source "config"

# Usage: api_get <path>
# Example: api_get "source_types?filter[name]=mock"
function api_get {
    if [[ -z $2 ]]; then
        api_path=${BASE_PATH}
    else
        api_path=$2
    fi
    curl -H "x-rh-identity: ${X_RH_IDENTITY}" \
         -H "x-rh-insights-request-id: 1" \
         --silent \
        "${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/${api_path}/$1"
}

# Usage: api_post <path> <data>
# Example: api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
function api_post {
    curl --request POST \
         --header "Content-Type: application/json" \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --header "x-rh-insights-request-id: 1" \
         --data "$2" \
         --silent \
         "${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/${BASE_PATH}/$1"
}

# Usage: api_delete <path>
# Example: api_delete "sources/1"
function api_delete {
    curl --request DELETE \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --header "x-rh-insights-request-id: 1" \
         --silent \
         "${TOPOLOGICAL_INVENTORY_API_SERVICE_HOST}:${TOPOLOGICAL_INVENTORY_API_SERVICE_PORT}/${BASE_PATH}/$1"
}

# Usage: api_get <path>
# Example: api_get "source_types?filter[name]=mock"
function sources_api_get {
    if [[ -z $2 ]]; then
        api_path=${SOURCES_API_BASE_PATH}
    else
        api_path=$2
    fi
    curl -H "x-rh-identity: ${X_RH_IDENTITY}" \
         --header "x-rh-insights-request-id: 1" \
         --silent \
        "${SOURCES_API_SERVICE_HOST}:${SOURCES_API_SERVICE_PORT}/${api_path}/$1"
}

# Usage: api_post <path> <data>
# Example: api_post "sources" "{\"name\":\"Mock Source 1\",\"source_type_id\":\"4\"}"
function sources_api_post {
    curl --request POST \
         --header "Content-Type: application/json" \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --header "x-rh-insights-request-id: 1" \
         --data "$2" \
         --silent \
         "${SOURCES_API_SERVICE_HOST}:${SOURCES_API_SERVICE_PORT}/${SOURCES_API_BASE_PATH}/$1"
}

# Usage: api_delete <path>
# Example: api_delete "sources/1"
function sources_api_delete {
    curl --request DELETE \
         --header "x-rh-identity: ${X_RH_IDENTITY}" \
         --header "x-rh-insights-request-id: 1" \
         --silent \
         "${SOURCES_API_SERVICE_HOST}:${SOURCES_API_SERVICE_PORT}/${SOURCES_API_BASE_PATH}/$1"
}

######################################
# @param api_get response
function records_count {
    local cnt=`echo $1 | jq '.meta.count'`
    echo ${cnt}
}
