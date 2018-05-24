# lets_oauth2_proxy

_.**oi**, the majority of this is **not** original work. all i've done is glue together amazing work done by other people, who are all credited at the bottom of this readme. enjoy._

This is an attempt to glue together linuxserver/letsencrypt and machinedata/oauth2_proxy. Instead of the common setup involving these two, where letsencrypt proxies to a separate oauth2_proxy container, it will proxy through localhost to oauth2, simplifying the network setup.

I'll add details on config and available parameters at some point, until then, see the original pages for information.

credit:
https://hub.docker.com/r/linuxserver/letsencrypt/
https://hub.docker.com/r/machinedata/oauth2_proxy/

Thanks to bogartusmaximus for nginx and oauth2_proxy config info.
https://github.com/bogartusmaximus/MediaVault-oauth2-reverse-proxy