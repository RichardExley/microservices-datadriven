#!/bin/bash
# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


# fail on error or undefined variable access
set -eu

echo "Installing ORDS"
yum -y install ords-21*
