count="60"
spacing="1" #seconds

# Each probe is run in a separate thread
for (( p=1; p<=$count; p++))
do
  ./probe.sh &
  sleep "$spacing"
done
