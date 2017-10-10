# GoCD Server/Agent using password-file

This `docker-compose.yml` provides a server/agent GoCD setup using `docker secret` to provide a `password.properties` file into the server.

## Additional GoCD stacks

Within the `openldap` directory a stack can be find using an openldap service instead of the `password.properties` file.
