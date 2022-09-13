probe_number="$1"
hatest_result_app_outage "client_send $probe_number get_1"
# wget http://127.0.0.1:8080/user/1
sleep 0.05
hatest_result_app_outage "client_response $probe_number get_1 200"