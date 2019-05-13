#!/usr/bin/env bash

source "config"
source "functions/source_type.sh"
source "functions/source.sh"
source "functions/namespace.sh"

oc project ${openshift_project}

echo "$(change_configmap_namespace ${config_file})" | oc apply -f -
echo "$(change_configmap_namespace ${data_config_file})" | oc apply -f -
echo ""
echo "* Creating Source Type if missing..."
source_type_id=$(find_or_create_source_type)
echo "Source Type ID: ${source_type_id}"

echo ""
existing=$(records_count "$(sources_api_get 'sources')")
sources_needed=$((sources_total - existing))

if [[ ${sources_needed} -eq 0 ]]; then
    echo "* ${existing}/${sources_total} Sources actually created, no db action"
elif [[ ${sources_needed} -gt 0 ]]; then
    echo "* ${sources_needed}/${sources_total} Sources are deployed..."
    create_sources ${source_type_id} ${sources_needed}

    echo "Done"
else
    echo "* ${existing}/${sources_total} Sources deployed, use ./cleanup.sh if you want less sources"
fi
echo ""
echo "* Deploying 1 mock-collector for each Source..."
deploy_sources
echo "Done"
