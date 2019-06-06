#!/usr/bin/env bash

source "functions/common.sh"

function query_source_type {
    local response=`sources_api_get "source_types?filter[name]=${source_type_name}"`
    echo ${response}
}

# @param `query_source_type` response
function parse_source_type_id {
    local source_type_id=`echo $1 | jq '.data[0].id | tonumber'`
    echo ${source_type_id}
}

# CREATE Mock-Source Type
function create_source_type {
    sources_api_post "source_types" "{\"name\":\"${source_type_name}\",\"product_name\":\"${source_type_name}\",\"vendor\":\"Red Hat\"}"
}

function find_or_create_source_type {
    local response=$(query_source_type)

    local source_types_cnt=$(records_count "${response}")
    local source_type_id=""
    if [[ "${source_types_cnt}" -ge "1" ]]; then
        source_type_id=$(parse_source_type_id "${response}")
    else
        local create_response=$(create_source_type)
        source_type_id=$(find_or_create_source_type)
    fi
    echo ${source_type_id}
}
