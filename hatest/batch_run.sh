batch_name="$1"
app_type="$2"
impls="$3"
workload="$4"
outages="$5"
results_file="$6"

log="$HATEST_LOG_DIR/${batch_name}.log"

eval "
function hatest_result() {
  local entry="'"$1"'"
  local current_epoch="'$(date +%s.%N)'"
  echo "'"'"$batch_name $app_type $workload "'$current_epoch $entry"'" >> $results_file
}
"
export -f hatest_result
env
for impl in ${impls[@]}
do
  $HATEST_CODE/app_run.sh "$batch_name" "$app_type" "$impl" "$workload" "$outages" >>$log 2>&1
done
