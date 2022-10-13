job_name="$1"
app_type="$2"
workload="$3"
outage="$4"
impl="$5"
impl_ver="$6"

eval "function hatest_result_app() {
  local entry="'"$1"'"
  hatest_result "'"'""'$entry"'"
}
"
export -f hatest_result_app

$HATEST_CODE/app_outage_run.sh "$job_name" "$app_type" "$workload" "$outage" "$impl" "$impl_ver" 
