count="300"
spacing="1.0" #seconds

# Each probe is run in a separate thread
for (( p=1; p<=$count; p++))
do
  if test "$(hatest_get_phase)" == 'rampdown'; then
    break
  fi
  ./probe.sh "$p" &
  sleep "$spacing"
done
