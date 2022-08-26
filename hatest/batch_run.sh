batch_name="$1"
apps="$2"
outages="$3"
results_file="$4"

log="$HATEST_LOG_DIR/${batch_name}.log"

function hatest_result() {
  local entry="$1"
  echo "$batch_name $entry" >> $results_file
  echo "HATEST_RESULT: $batch_name $entry" >> $log
}
export -f hatest_result

for app in ${apps(@)}
do
  $test_home/app_run.sh "$batch_name" "$app" "$outages"
done
