batch_name="$1"
app_type="$2"
impls="$3"
workload="$4"
outages="$5"
results_file="$6"

log="$HATEST_LOG_DIR/${batch_name}.log"

function hatest_set_phase() {
  local phase="$1"
  echo "$phase" > ~/.hatest_phase
}
export -f hatest_set_phase

function hatest_get_phase() {
  cat ~/.hatest_phase
}
export -f hatest_get_phase

eval "
function hatest_result() {
  local entry="'"$1"'"
  local current_epoch="'$(date +%s.%N)'"
  local phase="'$(hatest_get_phase)'"
  echo "'"'"{batch_name=$batch_name app_type=$app_type workload=$workload "'epoch=$current_epoch phase=$phase $entry}"'" >> $results_file
}
"
export -f hatest_result

hatest_set_phase batch_start

for impl in ${impls[@]}
do
  $HATEST_CODE/app_run.sh "$batch_name" "$app_type" "$impl" "$workload" "$outages" >>$log 2>&1
done

hatest_set_phase batch_end
