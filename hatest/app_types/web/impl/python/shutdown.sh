#!/bin/bash
# Copyright (c) 2023 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

hatest_result_app_outage 'action=reset_start'
if test -f ~/.web_python.pid; then
  kill -9 "$(<~/.web_python.pid)"
  rm ~/.web_python.pid
fi
hatest_result_app_outage 'action=reset_end'