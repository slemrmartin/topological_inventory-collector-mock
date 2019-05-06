#!/usr/bin/env bash

echo "Change IMAGE_NAMESPACE in templates to your openshift's project name"

oc process -f ./openshift/deploy/sources-database.yml | oc apply -f -
oc process -f ./openshift/deploy/sources-api.yml | oc apply -f -
oc process -f ./openshift/deploy/topological-inventory-persister | oc apply -f -
oc process -f ./openshift/deploy/topological-inventory-sources-sync.yml -p SOURCES_HOST=sources-api | oc apply -f -
