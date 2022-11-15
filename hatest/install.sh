#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

set -e

for ip in $HATEST_APP_NODE1_IP $HATEST_APP_NODE2_IP; do
  ssh -t -i $HATEST_APP_PRIV_SSH_KEY_FILE opc@$ip <<!
which git || sudo dnf -y install git

cd
mkdir -p ~/hatest
cd ~/hatest

if ! test -d microservices-datadriven; then
  git clone -b "hatest" https://github.com/richardexley/microservices-datadriven.git
fi

cd ~/hatest/microservices-datadriven
git pull
!

scp -i $HATEST_APP_PRIV_SSH_KEY_FILE $HATEST_APP_SOURCE_FILE opc@$ip:hatest/

scp -i $HATEST_APP_PRIV_SSH_KEY_FILE -R $TNS_ADMIN opc@$ip:

cd $HATEST_CODE/app_types/web
./remote_install $ip $HATEST_APP_PRIV_SSH_KEY_FILE 

done