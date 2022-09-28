batch_name="$1"
app_type="$2"
impl="$3"
workload="$4"
outages="$5"

eval "function hatest_result_app() {
  local entry="'"$1"'"
  hatest_result "'"'"impl=$impl "'$entry"'"
}
"
export -f hatest_result_app

for outage in ${outages[@]}
do
  $HATEST_CODE/app_outage_run.sh "$batch_name" "$app_type" "$impl" "$workload" "$outage"
done
