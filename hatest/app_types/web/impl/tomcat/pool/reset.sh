hatest_result_app_outage 'action=reset_start'
if test -f ~/.tomcat.pid; then
  kill -9 "$(<~/.web_python.pid)"
  rm ~/.tomcat.pid
fi
hatest_result_app_outage 'action=reset_end'