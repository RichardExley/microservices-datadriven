#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

cd $HATEST_CODE/app_types/web/impl/tomcat
./install.sh 
cd $HATEST_CODE/app_types/web/impl/python
./install.sh 
