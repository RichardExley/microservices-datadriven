batch_name="$1"
app_type="$2"
impl="$3"
workload="$4"
outage="$5"

eval "function hatest_result_app_outage() {
  local entry="'"$1"'"
  hatest_result_app "'"'"$outage "'$entry"'"
}
"
export -f hatest_result_app_outage

# Start the app
cd $HATEST_CODE/app_types/$app_type/$impl
./startup.sh

# Start the workload (async)
cd $HATEST_CODE/app_types/$app_type/workloads/$workload
./start.sh &

# Start the outage plan (async)
cd $HATEST_PLATFORM_CODE/outages
./start.sh "$outage" &

# Wait to completion
wait

# Reset the app
cd $HATEST_CODE/app_types/$app_type/$impl
./reset.sh
