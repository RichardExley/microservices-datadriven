## Copyright (c) 2021 Oracle and/or its affiliates.
## Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
import traceback
import logging
from flask import Flask, request
import oracledb
import sample_env
import simplejson

attempts = range(2)

# Dict Factory for Rows
def makeDictFactory(cursor):
    columnNames = [d[0] for d in cursor.description]
    def createRow(*args):
        return dict(zip(columnNames, args))
    return createRow

app = Flask(__name__)

# Display a welcome message on the 'home' page
@app.route('/')
def index():
    return "Welcome to the demo app"

# Show name of thing
@app.route("/thing/<int:id>")
def get_thing_by_id(thing_id):
    sql = "select id, name from thing where id = :id"
    conn = oracledb.connect(sample_env.get_main_connect_string())
    cursor = conn.cursor()
    cursor.execute(sql, [thing_id])
    cursor.rowfactory = makeDictFactory(cursor)
    thing = cursor.fetchone()
    conn.close()
    return simplejson.dumps(thing)

#------------------------------------------------------------------------------

if __name__ == '__main__':

    # Start a pool of connections
    pool = start_pool()

    # Create a demo table
    create_schema()

    # Start a webserver
    app.run(port=port)
