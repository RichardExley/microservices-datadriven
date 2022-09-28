probe_number="$1"
hatest_result_app_outage "action=client_send probe=$probe_number call=get_1"
HATEST_APP_URL='http://127.0.0.1:8080/user/1'
# get output, append HTTP status code in separate line, discard error message
OUT=$( curl --max-time 5 -qSfsw '\n%{time_total} %{http_code}' "${HATEST_APP_URL}?probe=${probe_number}" ) 2>/dev/null

# get exit code
RET=$?

status="$(echo "$OUT" | tail -n1 ) $RET"
hatest_result_app_outage "action=client_response probe $probe_number status="'"'"$status"'"'