FROM lsiobase/alpine.nginx:3.7

# set version label
LABEL build_version="0.1"
LABEL maintainer="digitalgrease"

# LETSENCRYPT STUFF
# environment settings
ENV DHLEVEL=4096 ONLY_SUBDOMAINS=false AWS_CONFIG_FILE=/config/dns-conf/route53.ini
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# install packages
RUN \
 apk add --no-cache \
	certbot \
	curl \
	fail2ban \
	memcached \
	nginx-mod-http-echo \
	nginx-mod-http-fancyindex \
	nginx-mod-http-geoip \
	nginx-mod-http-headers-more \
	nginx-mod-http-image-filter \
	nginx-mod-http-lua \
	nginx-mod-http-lua-upstream \
	nginx-mod-http-nchan \
	nginx-mod-http-perl \
	nginx-mod-http-redis2 \
	nginx-mod-http-set-misc \
	nginx-mod-http-upload-progress \
	nginx-mod-http-xslt-filter \
	nginx-mod-mail \
	nginx-mod-rtmp \
	nginx-mod-stream \
	nginx-mod-stream-geoip \
	nginx-vim \
	php7-bz2 \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-exif \
	php7-gd \
	php7-iconv \
	php7-mcrypt \
	php7-memcached \
	php7-mysqli \
	php7-mysqlnd \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-pgsql \
	php7-phar \
	php7-soap \
	php7-sockets \
	php7-sqlite3 \
	php7-tokenizer \
	php7-xml \
	php7-xmlreader \
	php7-zip \
	py2-future \
	py2-pip && \
 echo "**** install certbot plugins ****" && \
 pip install --no-cache-dir \
	certbot-dns-cloudflare \
	certbot-dns-cloudxns \
	certbot-dns-digitalocean \
	certbot-dns-dnsimple \
	certbot-dns-dnsmadeeasy \
	certbot-dns-google \
	certbot-dns-luadns \
	certbot-dns-nsone \
	certbot-dns-rfc2136 \
	certbot-dns-route53 && \
 echo "**** remove unnecessary fail2ban filters ****" && \
 rm \
	/etc/fail2ban/jail.d/alpine-ssh.conf && \
 echo "**** copy fail2ban default action and filter to /default ****" && \
 mkdir -p /defaults/fail2ban && \
 mv /etc/fail2ban/action.d /defaults/fail2ban/ && \
 mv /etc/fail2ban/filter.d /defaults/fail2ban/

# OAUTH STUFF
# add user and group first so their IDs don't change
RUN addgroup oauth2_proxy && adduser -G oauth2_proxy  -D -H oauth2_proxy

# su/sudo with proper signaling inside docker
RUN apk add --no-cache su-exec

ENV OAUTH2_PROXY_VERSION="2.2"

# install zeppelin
RUN set -xe \
    && apk add --no-cache --virtual .run-deps \
        bash \
        ca-certificates \
        curl \
    && apk add --no-cache --virtual .build-deps \
        tar \
    \
    && curl -O -fSL "https://github.com/bitly/oauth2_proxy/releases/download/v${OAUTH2_PROXY_VERSION}/oauth2_proxy-${OAUTH2_PROXY_VERSION}.0.linux-amd64.go1.8.1.tar.gz" \
    && mkdir /oauth2_proxy \
    && tar -xf oauth2_proxy-${OAUTH2_PROXY_VERSION}.0.linux-amd64.go1.8.1.tar.gz -C /oauth2_proxy --strip-components=1 --no-same-owner \
    && rm oauth2_proxy-${OAUTH2_PROXY_VERSION}.0.linux-amd64.go1.8.1.tar.gz \
    \
    && curl -O -fSL "https://raw.githubusercontent.com/bitly/oauth2_proxy/v${OAUTH2_PROXY_VERSION}/contrib/oauth2_proxy.cfg.example" \
    && mkdir /conf \
    && mv oauth2_proxy.cfg.example /conf/oauth2_proxy.cfg.dist \
    \
    && mkdir /templates \
    \
    && chown -R oauth2_proxy:oauth2_proxy /conf /templates /oauth2_proxy \
    \
    && apk del .build-deps

ENV PATH /oauth2_proxy:$PATH

VOLUME [ "/templates" ]

EXPOSE 4180

HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
    CMD curl --silent --fail http://localhost:4180/ping || exit 1

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
RUN chmod +x /docker-entrypoint.sh
CMD ["oauth2_proxy", "--config", "/conf/oauth2_proxy.cfg"]
# add local files
COPY root/ /
