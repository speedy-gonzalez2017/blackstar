FROM hone/mruby-cli
RUN apt-get update && apt-get install libcurl4-openssl-dev -y
