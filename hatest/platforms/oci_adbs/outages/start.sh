outage="$1"
cd "$outage"
hatest_result_app_outage plan_start
sleep 20
hatest_result_app_outage plan_inject
./inject.sh &
sleep 20
hatest_result_app_outage plan_recover
./recover.sh &
sleep 20
hatest_result_app_outage plan_end