job_name="$1"
app_type="$2"
workload="$3"
test="$4"
impl="$5"
impl_ver="$6"

eval "function hatest_result_app_test() {
  local entry="'"$1"'"
  hatest_result_app "'"'""'$entry"'"
}
"
export -f hatest_result_app_outage

# Deploy the app
hatest_set_phase app_deployment
cd $HATEST_CODE/app_types/$app_type
./deploy.sh $impl $impl_ver

# Start the outage plan (async)
cd $HATEST_CODE/tests/$test
./start.sh