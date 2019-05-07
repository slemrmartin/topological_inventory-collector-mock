#!/usr/bin/env bash

source "config"

function change_configmap_namespace {
    local yaml=$1
    local template=$(sed "s/namespace: \${config_file}/namespace: ${openshift_project}/g" $1)
    echo "${template}"
}

function change_deployment_namespace {
    local yaml=$1
    local template=$(sed "s/value: buildfactory/namespace: ${openshift_project}/g" $1)
    echo "${template}"
}
