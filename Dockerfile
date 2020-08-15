FROM lsiobase/nginx:3.12

# set version label
ARG BUILD_DATE
ARG VERSION
ARG GIST_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

ENV HOME="/config"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	composer \
	git \
	nodejs \
	npm && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	make \
	php7 \
	php7-dom \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-sqlite3 && \
 echo "**** install gist ****" && \
 git clone https://gitnet.fr/deblan/gist /app/gist && \
 cd /app/gist && \
 mkdir -p data/{git,cache} && \
 yes 2 | composer update && \
 npm install && \
 npm update && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /
