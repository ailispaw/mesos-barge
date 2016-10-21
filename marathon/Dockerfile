FROM ailispaw/ubuntu-essential:14.04

ENV TERM xterm

RUN apt-get -q update && \
    apt-get -q -y install --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get purge -y software-properties-common && \
    apt-get autoremove --purge -y && \

    apt-get -q update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    apt-get -q -y install --no-install-recommends oracle-java8-installer oracle-java8-set-default && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://repos.mesosphere.io/ubuntu trusty main" > /etc/apt/sources.list.d/mesosphere.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    apt-get -q update && \
    apt-get -q -y install --no-install-recommends mesos marathon && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "marathon", "--no-logger" ]
