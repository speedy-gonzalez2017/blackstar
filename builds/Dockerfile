FROM ubuntu:16.04
RUN mkdir -p /app
WORKDIR /app

RUN apt-get update && \
      apt-get -y install sudo wget

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo