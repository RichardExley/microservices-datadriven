batch_name="$1"
apps="$2"
outages="$3"
results_file="$4"

log="$HATEST_LOG_DIR/${batch_name}.log"

eval "
function hatest_result() {
  local entry="'"$1"'"
  local current_epoch="'$(date +%s.%N)'"
  echo "'"'"$batch_name "'$current_epoch $entry"'" >> $results_file
}
"
export -f hatest_result

for app in ${apps[@]}
do
  $HATEST_CODE/app_run.sh "$batch_name" "$app" "$outages" >>$log 2>&1
done
