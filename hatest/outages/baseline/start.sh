hatest_set_phase rampup
hatest_result_app_outage 'event=plan_start'
sleep 30
hatest_set_phase rampdown
sleep 2
hatest_result_app_outage 'event=plan_end'