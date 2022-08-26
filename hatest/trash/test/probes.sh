probes="$1"
declare -a probes_parse -a ($probes)
count=${probes_parse[0]}
spacing=${probes_parse[1]}
name=${probes_parse[2]}

# Each probe is run in a separate thread
for (( p=1; p<=$count; p++))
do
  ./probe_${name}.sh &
  sleep "$spacing"
done