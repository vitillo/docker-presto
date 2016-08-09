FROM airdock/oracle-jdk:1.8
MAINTAINER ra.vitillo@gmail.com

ENV PRESTO_VERSION 0.151
ENV DOCKERIZE_VERSION v0.2.0

RUN apt-get update && \
    apt-get install -y python python-pip wget less && \
    pip install crudini && \
    wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/$PRESTO_VERSION/presto-server-$PRESTO_VERSION.tar.gz -O /tmp/presto.tar.gz && \
    mkdir /opt/presto && \
    tar -zxvf /tmp/presto.tar.gz -C /opt/presto --strip-components=1 && \
    rm /tmp/presto.tar.gz && \
    wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.151/presto-cli-0.151-executable.jar -O /usr/local/bin/presto-cli && \
    chmod +x /usr/local/bin/presto-cli && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz


COPY resources/etc/* /opt/presto/etc/
ADD resources/etc/catalog/hive.properties /opt/presto/etc/catalog/hive.properties
ADD resources/entrypoint.sh entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
CMD ["/opt/presto/bin/launcher", "run"]