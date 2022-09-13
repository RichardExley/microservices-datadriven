batch_name="$1"
hatest_result_app_outage startup_start
export PYO_SAMPLES_MAIN_USER="$HATEST_DB_MAIN_USER"
export PYO_SAMPLES_MAIN_PASSWORD="$HATEST_DB_MAIN_PASSWORD"
export PYO_SAMPLES_CONNECT_STRING="$HATEST_DB_CONNECT_STRING"
export PYO_SAMPLES_DRIVER_MODE=thick
python3 connection_pool.py &
echo "$!" > ~/.web_python.pid
hatest_result_app_outage startup_end