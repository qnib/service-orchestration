# GoCD Server/Agent w/ OpenLDAP backend

Deploy the stack via `docker-app`:

```
$ docker-app deploy
Creating network gocd_default
Creating config gocd_gocd_config
Creating service gocd_slapd
Creating service gocd_server
Creating service gocd_agent
```

The same can be done using the pushed stack: `docker-app render qnib/gocd.dockerapp:0.1.0`
