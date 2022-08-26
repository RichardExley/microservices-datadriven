batch_name="$1"
app="$2"
outage="$3"

function hatest_result_app_outage() {
  local entry="$1"
  hatest_result_app "$outage $entry"
}
export -f hatest_result_app_outage

# Start the app
cd $HATEST_APP_TYPE_CODE/impl/$app
./startup.sh

# Start the workload (async)
cd $HATEST_WORKLOAD_CODE
./start.sh &

# Start the outage plan (async)
cd $HATEST_PLATFORM_CODE/outages
./start.sh "$outage" &

# Wait to completion
wait

# Reset the app
cd $HATEST_APP_TYPE_CODE/impl/$app
./reset.sh
