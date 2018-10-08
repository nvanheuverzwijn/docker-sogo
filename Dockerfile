FROM debian:buster-slim

ENV ENTRYPOINT_ROOT="entrypoint" \
    NGINX_CONF="" \
    SOGO_CONF=""

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      busybox-syslogd \
      ca-certificates \
      procps \
      sogo \
      nginx \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/kronostechnologies/docker-init-entrypoint/releases/download/1.3.1/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 443 20000

COPY docker/ /
