#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

impl_ver="$1"
export PYO_SAMPLES_MAIN_USER="$HATEST_DB_MAIN_USER"
export PYO_SAMPLES_MAIN_PASSWORD="$HATEST_DB_MAIN_PASSWORD"
export PYO_SAMPLES_CONNECT_STRING="$HATEST_DB_CONNECT_STRING"
export PYO_SAMPLES_DRIVER_MODE=thick
cd $impl_ver
python3 connection_pool.py &
echo "$!" > ~/.web_python.pid
