#!/usr/bin/env bash

source "functions/common.sh"
source "functions/source_type.sh"
source "functions/application.sh"

function sources_count {
    local response=$(sources_api_get 'sources')
    local cnt=$(records_count "${response}")

    echo ${cnt}
}

function create_source {
    local source_type_id=$1
    local source_no=$2

    local response=`sources_api_post "sources" "{\"name\":\"Mock Source ${source_no}\",\"source_type_id\":\"${source_type_id}\"}"`
    echo ${response}
}

function create_sources {
    local source_type_id=$1
    local cnt=$2

    local app_type_id=$(get_application_type_id)

    for i in `seq 1 ${cnt}`;
    do
        local source_id=$(create_source ${source_type_id} ${i} | jq -r '.id')
        create_application ${app_type_id} ${source_id}
    done
}
# Delete all sources of MockSource type
function delete_all_sources {
    local cnt=$(sources_count)

    local source_type_id=$(find_or_create_source_type)
    local response=$(sources_api_get "sources?filter\[source_type_id\]=${source_type_id}')")

    for source_id in $(echo ${response} | jq -r '.data[].id'); do
        echo "DELETE /sources/${source_id}"
        sources_api_delete "sources/${source_id}"
    done
    echo "Total deleted: ${cnt}"
}

function delete_pods_with_sources {
    local dcs=$(oc get dc | grep mock-collector | awk '{print $1}')

    for dc in ${dcs[@]}
    do
        oc delete deploymentconfig ${dc}
    done
    delete_all_sources
}

function deployment_for_source_id {
    local source_id=$1
    local name="topological-inventory-mock-collector-${source_id}"
    local rules=$(cat <<-EOF
.objects[0].metadata.name = \$CF_NAME |
.parameters[0].value=\$CF_NAMESPACE
EOF
    )

    local modified=$(cat 'openshift/deployments/topological-inventory-mock-collector.yml' | yq --arg CF_NAME ${name} --arg CF_NAMESPACE ${openshift_project} "${rules}")
    echo "${modified}"
}

function deploy_sources {
    local response=$(sources_api_get 'sources')

    local source_id
    local source_uid
    local param_no=0

    for param in $(echo ${response} | jq -r '.data[] | .id, .uid | tostring'); do
         if [[ ${param_no} -eq 0 ]]; then
            source_id=${param}
            param_no=1
         else
            source_uid=${param}
            local template=$(deployment_for_source_id ${source_id})
            echo "${template}" | \
            oc process -f - \
            -p CONFIG_NAME="custom" \
            -p DATA_CONFIG_NAME="custom" \
            -p SOURCE_UID=${source_uid} \
            | oc apply -f -

            param_no=0
         fi
    done
}
