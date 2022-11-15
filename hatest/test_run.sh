job_name="$1"
app_type="$2"
workload="$3"
test="$4"
impl="$5"
impl_ver="$6"

# Start promtail on each app node

# Start the test
cd $HATEST_CODE/tests/$test
./start.sh

# Stop promtail on each app node

