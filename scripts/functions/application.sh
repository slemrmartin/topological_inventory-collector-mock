#!/usr/bin/env bash

source "functions/common.sh"

function get_application_type_id {
  local response=$(sources_api_get "application_types?filter[name]=/insights/platform/topological-inventory" | jq -r '.data[].id')

  echo ${response}
}

function create_application {
  local application_type_id=$1
  local source_id=$2

  sources_api_post "applications" "{\"source_id\":\"${source_id}\",\"application_type_id\":\"${application_type_id}\",\"availability_status\":\"available\"}"
}

function create_applications {
  local application_type_id=$1
  local cnt=$2

  for i in `seq 1 ${cnt}`;
  do
    create_application ${application_type_id} ${i}
  done
}
