app_type="$1"
workload="$2"
outage="$3"
impl="$4"
impl_ver="$5"

job_id=`date +'%Y%m%d%H%m'`
job_name=${job_id}-${HATEST_PLATFORM}-${app_type}-${workload}-${outage}-${impl}-${impl_ver}
export HATEST_JOB_NAME="$job_name"

# Start Promtail
$HATEST_CODE/promtail_start.sh

echo "job_name=$job_name epoch=$(date +%s.%N) platform=$HATEST_PLATFORM app_type=$app_type workload=$workload outage=$outage impl=$impl impl_ver=$impl_ver" >>${HATEST_JOB_META_LOG}

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
  echo "'"'"job_name=$job_name "'epoch=$current_epoch phase=$phase $entry"'" >> ${HATEST_RESULTS_LOG}
}
"
export -f hatest_result

echo "Starting job $job_name"
hatest_set_phase batch_start

$HATEST_CODE/app_run.sh "$job_name" "$app_type" "$workload" "$outage" "$impl" "$impl_ver" >>${HATEST_APP_LOG} 2>&1

hatest_set_phase batch_end

# Stop Promtail
$HATEST_CODE/promtail_stop.sh
