#!/usr/bin/env bash

source "config"
source "functions/source_type.sh"
source "functions/source.sh"

# Create/change BuildConfig
oc process -f ./openshift/builds/topological-inventory-mock-collector.yml | oc apply -f -
# Build image
oc start-build topological-inventory-mock-collector
