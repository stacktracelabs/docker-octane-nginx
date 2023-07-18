#!/bin/bash

#exit on error
set -e

##########################
# Environment Settings
DEV_UPSTREAM_CHANNEL="beta-"

# UI Colors
function ui_set_yellow {
    printf $'\033[0;33m'
}

function ui_set_green {
    printf $'\033[0;32m'
}

function ui_set_red {
    printf $'\033[0;31m'
}

function ui_reset_colors {
    printf "\e[0m"
}

# Script Configurations
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

##########################
# Set versions to build
phpVersions=(8.2)

##########################
# Functions

function build (){
        label=$(echo $1 | tr '[:lower:]' '[:upper:]')
        ui_set_yellow && echo "⚡️ Running build for $label - ${2} ..." && ui_reset_colors

        # Use "docker build"
        docker build \
            --build-arg UPSTREAM_CHANNEL="${DEV_UPSTREAM_CHANNEL}" \
            --build-arg PHP_VERSION="${2}" \
            -t "stacktracelabs/php:beta-${2}-$1" \
            $SCRIPT_DIR/src/$1/

        ui_set_green && echo "✅ Build completed for $label - ${2} (stacktracelabs/php:beta-${2}-$1)" && ui_reset_colors
}

function build_versions {
    # Grab each PHP version defined in `build.sh` and deploy these images to our LOCAL registry
    for version in ${phpVersions[@]}; do
        build octane-nginx ${version[$i]}
    done
}

##########################
# Main script starts here
build_versions
