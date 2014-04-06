FROM redguava/centos
RUN yum install -y rsyslog python-dateutil
RUN mkdir -p /build && cd /build && curl -L -o s3cmd.tar.gz https://github.com/s3tools/s3cmd/archive/master.tar.gz && tar xzf s3cmd.tar.gz && cd s3cmd-master && python setup.py install && rm -rf /build
ADD rsyslog.conf /etc/rsyslog.conf
ADD supervisord-rsyslog.conf /etc/supervisord.d/rsyslog.conf
ADD supervisord-syslog_to_s3.conf /etc/supervisord.d/syslog_to_s3.conf
ADD start-syslog_to_s3.sh /start-syslog_to_s3.sh
ADD run.sh /run.sh

CMD /run.sh
