# lets_oauth2_proxy

This is an attempt to glue together linuxserver/letsencrypt and machinedata/oauth2_proxy. Instead of the common setup involving these two, where letsencrypt proxies to a separate oauth2_proxy container, it will proxy through localhost to oauth2, simplifying the network setup.

I'll add details on config and available parameters at some point, until then, see the original pages for information.

https://hub.docker.com/r/linuxserver/letsencrypt/
https://hub.docker.com/r/machinedata/oauth2_proxy/