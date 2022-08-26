batch_name="$1"
app="$2"
outages="$3"

function hatest_result_app() {
  local entry="$1"
  hatest_result "$app $entry"
}
export -f hatest_result_app

for outage in ${outages[@]}
do
  $HATEST_CODE/app_outage_run.sh "$batch_name" "$app" "$outage"
done
