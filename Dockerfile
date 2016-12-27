FROM python:2.7-alpine
MAINTAINER Sami Haahtinen <ressu@ressukka.net>

ENV SICKGEAR_VERSION 0.12.2

# Download gosu and SickGear.
RUN apk add --update \
      ca-certificates \
      curl \
      gcc \
      libxml2 \
      libxml2-dev \
      libxslt \
      libxslt-dev \
      musl-dev \
      su-exec \
      tzdata \
      && \
    mkdir /opt && \
    curl -SL "https://github.com/SickGear/SickGear/archive/release_${SICKGEAR_VERSION}.tar.gz" | \
      tar xz -C /opt && \
    mv /opt/SickGear-release_${SICKGEAR_VERSION} /opt/SickGear && \
    pip install --no-cache-dir lxml && \
    pip install --no-cache-dir -r /opt/SickGear/requirements.txt && \
    apk del \
      ca-certificates \
      curl \
      gcc \
      libxml2-dev \
      libxslt-dev \
      musl-dev \
      && \
    rm -rf /var/cache/apk/*

ENV APP_DATA="/data" PATH=/opt/SickGear:$PATH

EXPOSE 8081
VOLUME /data /tv /incoming

COPY template /template
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["SickBeard.py"]
