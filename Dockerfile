FROM redguava/centos
RUN yum install -y rsyslog
RUN yum --enablerepo epel-testing install -y s3cmd
ADD rsyslog.conf /etc/rsyslog.conf
ADD supervisord-rsyslog.conf /etc/supervisord.d/rsyslog.conf
ADD supervisord-syslog_to_s3.conf /etc/supervisord.d/syslog_to_s3.conf
ADD start-syslog_to_s3.sh /start-syslog_to_s3.sh
ADD run.sh /run.sh

CMD /run.sh
