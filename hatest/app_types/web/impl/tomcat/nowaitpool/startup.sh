batch_name="$1"
hatest_result_app_outage 'action=startup_start'
mvn tomcat7:run &
echo "$!" > ~/.tomcat.pid
sleep 15
# MAA Tip: Probe after startup
curl 'http://127.0.0.1:8080/user/1'
sleep 5
hatest_result_app_outage 'action=startup_end'