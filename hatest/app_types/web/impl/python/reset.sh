hatest_result_app_outage reset_start
if test -f ~/.web_python.pid; then
  kill -9 "$(<~/.web_python.pid)"
fi
hatest_result_app_outage reset_end