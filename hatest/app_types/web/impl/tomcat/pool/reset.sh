hatest_result_app_outage 'action=reset_start'
if test -f ~/.web_python.pid; then
  kill -9 "$(<~/.web_python.pid)"
  rm ~/.tomcat.pid
fi
hatest_result_app_outage 'action=reset_end'