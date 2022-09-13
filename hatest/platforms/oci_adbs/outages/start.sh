outage="$1"
cd "$outage"
hatest_set_phase rampup
hatest_result_app_outage plan_start
sleep 20
hatest_set_phase outage
hatest_result_app_outage plan_inject
./inject.sh &
sleep 60
hatest_set_phase recovery
hatest_result_app_outage plan_recover
./recover.sh &
sleep 60
hatest_set_phase rampdown
sleep 10
hatest_result_app_outage plan_end