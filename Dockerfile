FROM node:6.3-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

ENV REACT_SOURCE /usr/src/react

WORKDIR $REACT_SOURCE

COPY config.js /config.js

RUN set -x \
    && apt-get update \
    && apt-get install -y git \
    && apt-get install -y libhiredis-dev \
    && apt-get install -y node-gyp \
    && rm -rf /var/lib/apt/lists/*
RUN buildDeps=' \
    gcc \
    make \
    python \
    ' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/mirror-media/plate-model.git \
    && cd plate-model \
    && git pull \
    && cp /config.js ./api/ \
    && cp -rf . .. \
    && cd .. \
    && rm -rf plate-model \
    && npm install \
    && npm run build

EXPOSE 3000
CMD ["npm", "start"]
