# lets_oauth2_proxy

_.**oi**, the majority of this is **not** original work. all i've done is glue together amazing work done by other people, who are all credited at the bottom of this readme. enjoy._

This is an attempt to glue together linuxserver/letsencrypt and machinedata/oauth2_proxy. Instead of the common setup involving these two, where letsencrypt proxies to a separate oauth2_proxy container, it will proxy through localhost to oauth2, simplifying the network setup.

I'll add details on config and available parameters at some point, until then, see the original pages for information.

* By default, this is set to dhlevel 4096. if you wish to change this, add `-e DHLEVEL=[number]`.
    * btw, it takes a long time to generate a 4096 bit prime for this. go get coffee.
* This assumes your config files are in a share that can be mounted.
* for nginx config information, please see bogartusmaximus' link at the bottom of the readme.

```
docker run -d --restart=always \
--cap-add=NET_ADMIN \
--name=lets_oauth2_proxy \
-v /[PATH_TO_SHARE]/nginx:/config \
-v /[PATH_TO_SHARE]/oauth2_proxy:/conf \
-e EMAIL=[EMAIL_FOR_LETSENCRYPT] \
-e URL=[BASE_URL] \
-e SUBDOMAINS=[subdomain,subdomain,etc] \
-e VALIDATION=http \
-e OAUTH2_PROXY_CONFIG=/conf/oauth2_proxy.cfg \
-p 80:80 -p 443:443 -p 4180:4180 \
-e TZ=[TIMEZONE] \
digitalgrease/lets_oauth2_proxy; docker logs -f lets_oauth2_proxy
```

credit: <br/>
https://hub.docker.com/r/linuxserver/letsencrypt/ <br/>
https://hub.docker.com/r/machinedata/oauth2_proxy/

Thanks to bogartusmaximus for nginx and oauth2_proxy config info. <br/>
https://github.com/bogartusmaximus/MediaVault-oauth2-reverse-proxy