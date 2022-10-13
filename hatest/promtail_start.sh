mkdir -p $HATEST_PROMTAIL_HOME

if ! test -f $HATEST_PROMTAIL_HOME/promtail-linux-amd64; then
  # download promtail
  cd $HATEST_PROMTAIL_HOME
  wget https://github.com/grafana/loki/releases/download/v2.6.1/promtail-linux-amd64.zip
  unzip promtail-linux-amd64.zip
  rm promtail-linux-amd64.zip
fi

# Stop it if it is running
$HATEST_CODE/promtail_stop.sh

# Start it
nohup $HATEST_PROMTAIL_HOME/promtail-linux-amd64 -config.expand-env=true -config.file=$HATEST_CODE/promtail.yaml >$HATEST_LOG_DIR/promtail.log 2>&1 &
echo "$!" > $HATEST_PROMTAIL_PID_FILE
