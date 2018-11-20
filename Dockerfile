FROM debian:jessie-slim

ENV ENTRYPOINT_ROOT="entrypoint" \
    NGINX_CONF="" \
    SOGO_CONF=""

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      busybox-syslogd \
      ca-certificates \
      gnupg \
      procps \
      nginx \
    && rm -rf /var/lib/apt/lists/*
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 0x810273C4 && \
    echo "deb http://packages.inverse.ca/SOGo/nightly/4/debian/ jessie jessie" >> /etc/apt/sources.list && \
    mkdir -p /usr/share/doc/sogo && touch /usr/share/doc/sogo/nothing.sh && \
    apt-get update && \
    apt-get install sogo sope4.9-gdl1-mysql -y && \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/kronostechnologies/docker-init-entrypoint/releases/download/1.3.1/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 443 20000

COPY docker/ /
