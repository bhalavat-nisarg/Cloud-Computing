# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y sysbench
ADD DOCKER.tar.gz .
COPY SETUP.sh .
RUN chmod -R 777 /DOCKER && cd /DOCKER && mv *.sh ../
