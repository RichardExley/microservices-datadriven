#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

ip="$1"
ssh_file="$2"

ssh -t -i $ssh_file ops@$ip <<!
which git || sudo dnf -y install git

cd
mkdir -p ~/hatest
cd ~/hatest

if ! test -d microservices-datadriven; then
  git clone -b "hatest" https://github.com/richardexley/microservices-datadriven.git
fi

cd ~/hatest/microservices-datadriven
git pull

cd ~/hatest/microservices-datadriven/hatest/app_types/web
./install.sh 
!