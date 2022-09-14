#------------------------------------------------------------------------------
# Copyright (c) 2022, Oracle and/or its affiliates.
#
# This software is dual-licensed to you under the Universal Permissive License
# (UPL) 1.0 as shown at https://oss.oracle.com/licenses/upl and Apache License
# 2.0 as shown at http://www.apache.org/licenses/LICENSE-2.0. You may choose
# either license.
#
# If you elect to accept the software under the Apache License, Version 2.0,
# the following applies:
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# connection_pool.py
#
# Demonstrates the use of connection pooling using a Flask web application.
#
# Connection Pools can significantly reduce connection times for long running
# applications that repeatedly open and close connections.  Connection pools
# allow multiple, concurrent web requests to be efficiently handled.  Internal
# features help protect against dead connections, and also aid use of Oracle
# Database features such as FAN and Application Continuity.
#
# Install Flask with:
#   pip install --upgrade Flask
#
# The default route will display a welcome message:
#   http://127.0.0.1:8080/
#
# To find a username you can pass an id, for example 1:
#   http://127.0.0.1:8080/user/1
#
# To insert new a user 'fred' you can call:
#   http://127.0.0.1:8080/post/fred
#------------------------------------------------------------------------------

import os
import oracledb
from flask import Flask
from flask import request
import sample_env

# Port to listen on
port=int(os.environ.get('PORT', '8080'))

# determine whether to use python-oracledb thin mode or thick mode
if not sample_env.get_is_thin():
    oracledb.init_oracle_client(lib_dir=sample_env.get_oracle_client())

#------------------------------------------------------------------------------

# start_pool(): starts the connection pool
def start_pool():

    # Generally a fixed-size pool is recommended, i.e. pool_min=pool_max.  Here
    # the pool contains 4 connections, which will allow 4 concurrent users.

    pool_min = 4
    pool_max = 4
    pool_inc = 0

    pool = oracledb.create_pool(user=sample_env.get_main_user(),
                                password=sample_env.get_main_password(),
                                dsn=sample_env.get_connect_string(),
                                min=pool_min,
                                max=pool_max,
                                increment=pool_inc,
                                getmode=oracledb.POOL_GETMODE_NOWAIT)

    return pool

# create_schema(): drop and create the demo table, and add a row
def create_schema():
    with pool.acquire() as connection:
        with connection.cursor() as cursor:
            cursor.execute("""
                begin
                  begin
                    execute immediate 'drop table demo';
                    exception when others then
                      if sqlcode <> -942 then
                        raise;
                      end if;
                  end;

                  execute immediate 'create table demo (
                       id       number generated by default as identity,
                       username varchar2(40))';

                  execute immediate
                         'insert into demo (username) values (''chris'')';

                  commit;
                end;""")

#------------------------------------------------------------------------------

app = Flask(__name__)

# Display a welcome message on the 'home' page
@app.route('/')
def index():
    return "Welcome to the demo app"

# Show the username for a given id
@app.route('/user/<int:id>')
def show_username(id):
    app.logger.warning("Probe: %s" % request.args.get('probe','NO-PROBE'))
    with pool.acquire() as connection:
        with connection.cursor() as cursor:
            cursor.execute("select username from demo where id = :idbv", [id])
            r = cursor.fetchone()
            return r[0] if r is not None else "Unknown user id"

#------------------------------------------------------------------------------

if __name__ == '__main__':

    # Start a pool of connections
    pool = start_pool()

    # Create a demo table
    create_schema()

    # Start a webserver
    app.run(port=port)
