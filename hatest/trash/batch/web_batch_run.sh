batch_name="$1"
app_type="$2"
apps="$3"
workload="$4"
outages="$5"

for app in ${apps(@)}
do
  $test_home/app_run.sh "$app"
done
