#!/usr/bin/env bash

source "config"
source "functions/namespace.sh"

oc project ${openshift_project}

echo " Deploying Group 1"

echo "$(change_deployment_namespace './openshift/deployments/topological-inventory-database.yml')" | oc process -f - | oc apply -f -
echo "$(change_deployment_namespace './openshift/deployments/sources-database.yml')" | oc process -f - | oc apply -f -

echo "* Deploying Group 2"

echo "$(change_deployment_namespace './openshift/deployments/topological-inventory-persister.yml')" | oc process -f - | oc apply -f -
echo "$(change_deployment_namespace './openshift/deployments/topological-inventory-ingress-api.yml')" | oc process -f - | oc apply -f -
echo "$(change_deployment_namespace './openshift/deployments/sources-api.yml')" | oc process -f - | oc apply -f -
echo "$(change_deployment_namespace './openshift/deployments/topological-inventory-api.yml')" | oc process -f - | oc apply -f -

echo "* Deploying Group 3"

echo "$(change_deployment_namespace './openshift/deployments/topological-inventory-sources-sync.yml')" | oc process -p SOURCES_HOST=sources-api -f - | oc apply -f -

echo "* Deploying Group 4"

./mock-source-deploy.sh
