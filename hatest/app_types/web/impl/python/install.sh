#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

sudo python3 -m pip install -U pip setuptools
sudo python3 -m pip install flask oracledb
sudo dnf -y install oraclelinux-developer-release-el8
sudo dnf -y install oracle-instantclient-release-el8
sudo dnf -y install oracle-instantclient-basic