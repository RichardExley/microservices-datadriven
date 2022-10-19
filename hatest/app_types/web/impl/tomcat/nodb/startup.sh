hatest_result_app_outage 'action=startup_start'
mvn tomcat7:run &
echo "$!" > ~/.tomcat.pid
sleep 10
hatest_result_app_outage 'action=startup_end'