probe_number="$1"
hatest_result_app_outage "client_send $probe_number get_1"
HATEST_APP_URL='http://127.0.0.1:8080/user/1'
# get output, append HTTP status code in separate line, discard error message
OUT=$( curl -qSfsw '\n%{http_code}' "$HATEST_APP_URL" ) 2>/dev/null

# get exit code
RET=$?

if [[ $RET -ne 0 ]] ; then
    # print HTTP error
    status="$(echo "$OUT" | tail -n1 ), return code $RET"
else
    # otherwise print last line of output, i.e. HTTP status code
    status="$(echo "$OUT" | tail -n1 )"
fi
hatest_result_app_outage "client_response $probe_number get_1 $status"