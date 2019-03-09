# Kafka Container 

A simple docker kafka container with with an embedded zookeper. Useful for running as part of gitlab CI.  

This repository is a modification from `MartinNowak`'s [repository](https://github.com/MartinNowak/docker-kafka)

## Docker-Hub

[Docker-Hub](https://cloud.docker.com/repository/docker/ros65536/kafka/general)

[![](https://images.microbadger.com/badges/image/ros65536/kafka.svg)](https://microbadger.com/images/ros65536/kafka "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/ros65536/kafka.svg)](https://microbadger.com/images/ros65536/kafka "Get your own version badge on microbadger.com")

# Instructions

## Build image 

For kafka:2.1.1 example:

```bash
$ docker build --build-arg KAFKA_VERSION=2.1.1 -t <you username>/kafka:2.1.1 .
```

## Run image 

```bash
$ docker run -p 2181:2181/tcp -p 9092:9092/tcp <you username>/kafka
```

## docker-compose.yml example

A working docker-compose example

```yaml
kafka:
    image: ros65536/kafka:2.1.1
    ports:
      - "9092:9092"
      - "2181:2181"
    volumes:
      - ./tmp/kafka:/var/lib/kafka
    environment:
      ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
      BROKER_ID: 1
```

# Options

## Env Options

Optionally use specific broker id, `docker run --rm -it --env=BROKER_ID=1 ros65536/kafka`.
```
# generate unique id by default
ENV BROKER_ID=-1
```

## Volume

Optionally mount persistent volume, `docker run --rm -it --volume=/tmp/host/kafka:/var/lib/kafka ros65536/kafka`.
```
VOLUME /var/lib/kafka
```

## Ports

Optionally publish ports on host, `docker run --rm -it --publish=2181:2181 --publish=9092:9092 ros65536/kafka`.
```
EXPOSE 2181/tcp 9092/tcp
```

## Build Options

Optionally build with a different version, `docker build --build-arg=KAFKA_VERSION=0.11.0.2 .`.
```
ARG KAFKA_VERSION=1.0.0
ARG SCALA_VERSION=2.11
```

