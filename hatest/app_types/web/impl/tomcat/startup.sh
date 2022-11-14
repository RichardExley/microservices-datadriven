#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

impl_ver="$1"
hatest_result_app_outage 'action=startup_start'
cd $impl_ver
mvn tomcat7:run &
echo "$!" > ~/.tomcat.pid
sleep 10
hatest_result_app_outage 'action=startup_end'