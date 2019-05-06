#!/usr/bin/env bash

source "config"
source "functions/source_type.sh"
source "functions/source.sh"

oc apply -f ${config_file}
oc apply -f ${amounts_config_file}

echo "Creating Source Type if missing..."
source_type_id=$(find_or_create_source_type)
echo "Source Type ID: ${source_type_id}"

create_sources ${source_type_id} ${sources_count}

deploy_sources
