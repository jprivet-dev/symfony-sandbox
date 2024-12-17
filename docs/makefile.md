# Makefile - Variables overloading

⬅️ [README](../README.md)

## overload/.env

You can customize the Docker build and up processes. To do this, create an `overload/.env` file and override the following variables :

```dotenv
# overload/.env

# See https://docs.docker.com/compose/how-tos/project-name/
PROJECT_NAME=my-project

# See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
COMPOSE_UP_SERVER_NAME=my.localhost
COMPOSE_UP_ENV_VARS=SYMFONY_VERSION=6.4.* HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443

# See https://docs.docker.com/reference/cli/docker/compose/build/#options
COMPOSE_BUILD_OPTS=--no-cache
```

These variables will be taken into account by the `make` commands.

> As the variables are common to the `Makefile` and `docker compose`, I'm not attaching an environment file with the `--env-file` option at the moment. See https://docs.docker.com/compose/how-tos/environment-variables/.

## Resources

- https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options
