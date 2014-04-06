#!/bin/bash

/etc/init.d/rsyslog start

INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)

while true; do
  SYSLOG_S3_SYNC_INTERVAL=$(etcdctl --peers ${ETCD_PEER} get /config/SYSLOG_S3_SYNC_INTERVAL | egrep -v "Error: 100: Key not found|Cannot sync with the cluster" || echo "300")
  SYSLOG_S3_BUCKET=$(etcdctl --peers ${ETCD_PEER} get /config/SYSLOG_S3_BUCKET | egrep -v "Error: 100: Key not found|Cannot sync with the cluster" || echo "syslog_to_s3")
  SYSLOG_S3_ACCESS_KEY=$(etcdctl --peers ${ETCD_PEER} get /config/SYSLOG_S3_ACCESS_KEY | egrep -v "Error: 100: Key not found|Cannot sync with the cluster")
  SYSLOG_S3_SECRET_KEY=$(etcdctl --peers ${ETCD_PEER} get /config/SYSLOG_S3_SECRET_KEY | egrep -v "Error: 100: Key not found|Cannot sync with the cluster")

  /usr/bin/s3cmd -m text/plain sync /var/log/rsyslog/* s3://${SYSLOG_S3_BUCKET}/${INSTANCE_ID}/

  sleep $SYSLOG_S3_SYNC_INTERVAL
done

