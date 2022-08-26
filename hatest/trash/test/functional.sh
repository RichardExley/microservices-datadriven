app_folder="$1"
platform_folder="$2"
failure_script="$3"
recovery_script="$4"

# STARTUP
$platform_folder/startup.sh
$app_folder/startup.sh

# WARM-UP PROBES
./probe.sh W 10 1000

# BASELINE PROBES
./probe.sh B 10 1000

# INJECT FAILURE (async)
$failure_script &

# FAILURE PROBES
./probe.sh F 10 1000

# BEGIN RECOVERY (async)
$recovery_script &

# RECOVERY PROBES
./probe.sh R 10 1000

# COLLECT RESULTS
./collect.sh
$app_folder/collect.sh
$platform_folder/collect.sh

# RESET
$app_folder/reset.sh
$platform_folder/reset.sh
