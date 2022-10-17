ssh -i $HATEST_DB_PRIV_SSH_KEY_FILE $HATEST_DB_NODE1_IP <<!
sudo su - oracle
sqlplus / as sysdba <<EOF
shutdown abort
EOF
!
