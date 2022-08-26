run_name="$1"
app_folder="$2"
probes="$3"
transitions="$4"
duration="$5"
log_folder="$6"
log_file="$log_folder/${run_name}.log"

$app_folder/start.sh >>$log_file 2>&1

./probes.sh "$probes" >>$log_file 2>&1 &

./transitions.sh "$transitions" >>$log_file 2>&1 &

sleep "$duration"

# Kill child processes

$app_folder/shutdown.sh >>$log_file 2>&1

$app_folder/cleanup.sh >>$log_file 2>&1