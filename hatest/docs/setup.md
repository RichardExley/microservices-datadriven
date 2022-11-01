# K6
sudo dnf install https://dl.k6.io/rpm/repo.rpm
sudo dnf install k6

# Loki
mkdir loki
cd loki
wget https://github.com/grafana/loki/releases/download/v2.6.1/loki-linux-amd64.zip
unzip loki-linux-amd64.zip
wget https://raw.githubusercontent.com/grafana/loki/master/cmd/loki/loki-local-config.yaml
rm *.zip
# remove query range section from yaml (bug)
sudo firewall-cmd --zone=public --add-port 3100/tcp --permanent
sudo systemctl restart firewalld

Data source to access Loki from grafana is http://<IP>:3100

## To Start Loki:
nohup ./loki-linux-amd64 -config.file=loki-local-config.yaml >loki.log 2>&1 &

# Grafana
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-9.2.0-1.x86_64.rpm
sudo yum install grafana-enterprise-9.2.0-1.x86_64.rpm
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo systemctl enable grafana-server
sudo firewall-cmd --zone=public --add-port 3000/tcp --permanent
sudo systemctl restart firewalld
# Open port 3000 to Internet on public compute NSG
# Connect to IP:3000 admin/admin and change password to Welcome1

# RAC DB Service
srvctl add service -db TESTBED_iad1mw -pdb TESTBED_PDB1 -service WEB -preferred TESTBED1,TESTBED2
srvctl start service -db TESTBED_iad1mw -s WEB
sqlplus admin/WELcome12345##@testbed-scan.publ.dcmsdb.oraclevcn.com:1521/testbed_pdb1.publ.dcmsdb.oraclevcn.com

# Admin user in PDB
alter session set container=TESTBED_PDB1;
create user admin identified by WELcome12345##;
grant unlimited tablespace, connect, resource to admin;

# GIT
sudo yum install git

# Python
sudo python3 -m pip install -U pip setuptools
sudo python3 -m pip install flask oracledb

# Oracle Instance Client
sudo dnf -y install oraclelinux-developer-release-el8
sudo dnf install oracle-instantclient-release-el8
sudo dnf install oracle-instantclient-basic
sudo dnf install oracle-instantclient-sqlplus
export PATH=/usr/lib/oracle/21/client64/bin:$PATH

# OCI CLI
sudo dnf install python36-oci-cli
oci setup config

# Java and Maven
sudo yum install jdk-19
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar xzvf apache-maven-3.8.6-bin.tar.gz
export PATH=~/apache-maven-3.8.6/bin:$PATH
rm apache-maven-3.8.6-bin.tar.gz
mvn -v

# Get Latest Code
mkdir ~/hatest
cd ~/hatest
time git clone -b "hatest" --single-branch https://github.com/richardexley/microservices-datadriven.git

# Run a Test
cd ~/hatest
source */hatest/source.env oci_adbs
$HATEST_CODE/job_run.sh web getk6 baseline tomcat nodb
