FROM ubuntu:16.04
RUN mkdir -p /app
WORKDIR /app

RUN apt-get update && \
      apt-get -y install sudo wget

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

COPY ./linux-x64 /tmp/linux-x64
RUN /tmp/linux-x64 init