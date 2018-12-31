# GoCD Server/Agent w/ OpenLDAP backend

## Setup
To get a password that you know about use:
```
$ python -c "import sha; from base64 import b64encode; print \"user=\"+b64encode(sha.new('awesomePass1').digest())" > gocd_password_properties
$ python -c "import sha; from base64 import b64encode; print \"admin=\"+b64encode(sha.new('awesomePass2').digest())" >> gocd_password_properties
```

## FFMPEG
This stack deploys the multi-features pipelines for qnib/ffmpeg. To deploy it you need to get the experimental version of docker-app (with templating support).

```
$ docker-app-experimental deploy \
      -s gocd.agent.workeronly=true \
      -s docker.user=moby \
      -s docker.registry="your-registry (default: docker.io)" \
      gocd-ffmpeg
```
`gocd.agent.workeronly=true` limits the global deployment to worker nodes.
