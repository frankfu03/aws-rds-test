#!/usr/bin/env bash

set -e

# Build, test and verify all Java components
mvn clean -s./maven-settings.xml install -DskipSystemTests
