#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

which java || sudo dnf -y install jdk-19

if ! test -d ~/apache-maven-3.8.6; then
  wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
  tar xzvf apache-maven-3.8.6-bin.tar.gz
  rm apache-maven-3.8.6-bin.tar.gz
fi
