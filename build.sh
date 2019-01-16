#!/usr/bin/env bash

set -e

function usage {
    echo "Usage: ./build.sh <env>
        where
        env
            deployment environment, eg., dev, test, prod"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case $1 in
        dev|test|prod )
            env=$1
            shift
            ;;
        * )
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

if [ -z $env ]; then
    echo "Error: deployment environment is empty."
    usage
fi

# Build, test and verify all Java components
mvn clean -s./maven-settings.xml install -P${env} -DskipSystemTests
