FROM openjdk:8-jre-alpine

MAINTAINER ros65536

ARG KAFKA_VERSION=1.0.0
ARG SCALA_VERSION=2.11

# generate unique id by default
ENV BROKER_ID=-1
ENV ADVERTISED_LISTENERS="PLAINTEXT://localhost:9092"

EXPOSE 2181/tcp 9092/tcp

RUN wget --quiet "http://www.apache.org/dyn/closer.cgi?action=download&filename=/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" -O /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz 
RUN wget --quiet https://www.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc -P /tmp/ 
RUN wget --quiet https://kafka.apache.org/KEYS -P /tmp/ 
RUN apk add --no-cache gnupg 
RUN gpg2 --import /tmp/KEYS 
RUN gpg2 --verify /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz 
RUN gpgconf --kill gpg-agent 
RUN apk del --purge gnupg 
RUN rm -r ~/.gnupg 
RUN mkdir -p /opt 
RUN tar -C /opt -zxf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz 
RUN rm /tmp/KEYS /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz.asc 
RUN ln -s kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka 
RUN sed -i 's|^log.dirs=.*$|log.dirs=/var/lib/kafka|' /opt/kafka/config/server.properties 
# for kafka scripts
RUN apk add --no-cache bash

VOLUME /var/lib/kafka

CMD sed -i "s|^broker.id=.*$|broker.id=$BROKER_ID|" /opt/kafka/config/server.properties && \
    /opt/kafka/bin/zookeeper-server-start.sh -daemon /opt/kafka/config/zookeeper.properties && \
    /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties --override advertised.listeners=$ADVERTISED_LISTENERS