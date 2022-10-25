job_name="$1"
app_type="$2"
workload="$3"
outage="$4"
impl="$5"
impl_ver="$6"

eval "function hatest_result_app_outage() {
  local entry="'"$1"'"
  hatest_result_app "'"'""'$entry"'"
}
"
export -f hatest_result_app_outage

# Start the app
hatest_set_phase app_startup
cd $HATEST_CODE/app_types/$app_type/impl/$impl/$impl_ver
./startup.sh

# Start the outage plan (async)
cd $HATEST_CODE/outages/$outage
./start.sh &

# Start the workload (async)
cd $HATEST_CODE/app_types/$app_type/workloads/$workload
./start.sh &

# Wait to completion
wait

# Reset the app
hatest_set_phase app_reset
cd $HATEST_CODE/app_types/$app_type/impl/$impl/$impl_ver
./reset.sh
