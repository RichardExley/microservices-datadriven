if ! test -f $HATEST_CODE/promtail-linux-amd64; then
  # download promtail
  wget https://github.com/grafana/loki/releases/download/v2.6.1/promtail-linux-amd64.zip
  unzip promtail-linux-amd64.zip
  rm promtail-linux-amd64.zip
fi

nohup $HATEST_CODE/promtail-linux-amd64 -config.file=promtail.yaml >$HATEST_LOG_DIR/promtail.log 2>&1 &
echo "$!" > $HATEST_PROMTAIL_PID_FILE
