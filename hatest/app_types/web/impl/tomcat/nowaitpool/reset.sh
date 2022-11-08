hatest_result_app_outage 'action=reset_start'
if test -f ~/.tomcat.pid; then
  kill -9 "$(<~/.tomcat.pid)"
  rm ~/.tomcat.pid
fi
hatest_result_app_outage 'action=reset_end'