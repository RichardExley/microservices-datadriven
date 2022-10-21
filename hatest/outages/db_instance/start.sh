outage="$1"
cd "$outage"
hatest_set_phase rampup
hatest_result_app_outage 'event=plan_start'
sleep 20

hatest_set_phase outage
hatest_result_app_outage 'event=plan_inject'
script=$HATEST_CODE/platforms/$HATEST_PLATFORM/outages/db_instance/inject.sh
if test -f $script; then
  eval "$script &"
else
  echo "Error: $script does not exist"
fi
sleep 60

hatest_set_phase recovery
hatest_result_app_outage 'event=plan_recover'
script=$HATEST_CODE/platforms/$HATEST_PLATFORM/outages/db_instance/recover.sh
if test -f $script; then
  eval "$script &"
else
  echo "Error: $script does not exist"
fi
sleep 60

hatest_set_phase rampdown
sleep 5
hatest_result_app_outage 'event=plan_end'