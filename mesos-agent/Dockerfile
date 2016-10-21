FROM ailispaw/ubuntu-essential:14.04

ENV TERM xterm

RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    apt-get -q update && \
    apt-get -q -y install --no-install-recommends mesos && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# A bug in 1.0.1; A workaround puts a dummy init for systemd checking to fail.
RUN ln -s /bin/false /sbin/init

ENV MESOS_WORK_DIR /tmp/mesos
ENV MESOS_CONTAINERIZERS docker,mesos

# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins

# https://issues.apache.org/jira/browse/MESOS-4675
ENV MESOS_SYSTEMD_ENABLE_SUPPORT false

VOLUME /tmp/mesos

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "mesos-agent" ]
