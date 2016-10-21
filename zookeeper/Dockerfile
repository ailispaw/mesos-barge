FROM ailispaw/ubuntu-essential:14.04

ENV TERM xterm

RUN apt-get -q update && \
    apt-get -q -y install --no-install-recommends zookeeper && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME /tmp/zookeeper

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

ENV PATH "${PATH}:/usr/share/zookeeper/bin"

CMD [ "zkServer.sh", "start-foreground" ]
