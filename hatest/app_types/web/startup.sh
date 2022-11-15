#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

impl="$1"
impl_ver="$2"

cd ~/hatest/microservices-datadriven/hatest/app_types/web/impl/$impl
./startup.sh $impl_ver
