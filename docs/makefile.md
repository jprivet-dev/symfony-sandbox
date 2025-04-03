# Makefile: use Docker build options

⬅️ [README](../README.md)

You can use the same variables from https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#docker-build-options with the `Makefile`:

```dotenv
# .env.local
SERVER_NAME=my.localhost
```

> As the variables are common to the `Makefile` and `docker compose`, I'm not attaching an environment file with the `--env-file` option at the moment. See https://docs.docker.com/compose/how-tos/environment-variables/.
