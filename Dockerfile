FROM alpine:3.7
ENV SCOUT_DATABASE=/data/search-index.db

# Install Python deps and ensure peewee C extensions are compiled.
RUN apk add --no-cache --virtual .build-deps build-base python3-dev \
      && apk add --no-cache libev python3 py3-pip sqlite-dev sqlite libffi-dev \
      && pip3 install --no-cache-dir cython \
      && pip3 install --no-cache-dir gevent \
      && apk del .build-deps

COPY ./docker/server /srv/
COPY setup.py README.md scout_client.py runtests.py /app/
COPY ./scout/ /app/scout

WORKDIR /app
RUN python3 setup.py install

EXPOSE 9004
VOLUME /data/

WORKDIR /data
ENTRYPOINT ["python3", "/srv/server.py", "-H", "0.0.0.0", "-p", "9004", "-s", "porter", "-l", "/data/scout.log"]
