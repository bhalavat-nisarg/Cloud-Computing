# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y sysbench
ADD DOCKER.tar.gz .
RUN chmod -R 777 /DOCKER

