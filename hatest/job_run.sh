app_type="$1"
test="$2"
workload="$3"
impl="$4"
impl_ver="$5"

job_id=`date +'%Y%m%d%H%M%S'`
job_name=${job_id}-${HATEST_PLATFORM}-${app_type}-${test}-${workload}-${impl}-${impl_ver}

# Start Local Promtail
$HATEST_CODE/promtail_start.sh

echo "Starting job $job_name"

echo "job_name=$job_name epoch=$(date +%s.%N) platform=$HATEST_PLATFORM app_type=$app_type workload=$workload outage=$outage impl=$impl impl_ver=$impl_ver" >>${HATEST_JOB_META_LOG}

$HATEST_CODE/test_run.sh "$job_name" "$app_type" "$test" "$workload" "$impl" "$impl_ver"

# Stop Local Promtail
$HATEST_CODE/promtail_stop.sh
