#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

ip="$1"
ssh_file="$2"
impl="$3"
impl_ver="$4"

ssh -t -i $ssh_file opc@$ip <<!
if ! test -d ~/hatest/microservices-datadriven; then
  echo 'Error: Not installed. Run install first"
  exit 1
fi

cd ~/hatest/microservices-datadriven/hatest/app_types/web
./shutdown.sh $impl $impl_ver
!
