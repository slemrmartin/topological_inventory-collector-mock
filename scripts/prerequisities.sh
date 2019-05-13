#!/usr/bin/env bash

if [[ "$(uname)" == "Darwin" ]]; then
    brew install jq
    brew install python-yq
else
    sudo dnf install jq
    sudo pip install yq
fi
