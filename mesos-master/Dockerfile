FROM ailispaw/ubuntu-essential:14.04

ENV TERM xterm

RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    apt-get -q update && \
    apt-get -q -y install --no-install-recommends mesos && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV MESOS_WORK_DIR /tmp/mesos

VOLUME /tmp/mesos

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "mesos-master" ]
