# Symfony sandbox

## Presentation

Symfony experimentation area.

- It was initially generated with https://github.com/jprivet-dev/symfony-starter.
- Based primarily on :
  - [Symfony Docker](https://github.com/dunglas/symfony-docker).
  - [Symfony Demo Application](https://github.com/symfony/demo).
  - [Tailwind Nextjs Starter Blog](https://github.com/timlrx/tailwind-nextjs-starter-blog).

## Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## Installation

### The very first time
 
- `git clone git@github.com:jprivet-dev/symfony-sandbox.git`
- `cd symfony-sandbox`
- `make first`:
  - Build fresh images.
  - Start the containers.
  - Install dependencies.
  - Fix permissions.
  - Init Git hook pre-push.
  - Show info.
- Go on https://symfony-sandbox.localhost/.

All in one:

```shell
git clone git@github.com:jprivet-dev/symfony-sandbox.git \
&& cd symfony-sandbox \
&& make first
```

### The following times

```shell
make start    # Start the project
make stop     # Stop the project
make restart  # Stop and start the project
make install  # Install all (for example, after an update of your curent branch)
```

> Run `make` to see all shorcuts for the most common tasks.

## Docs

1. [Makefile - Variables overloading](docs/makefile.md)
2. [Database - PostgreSQL](docs/database-postgre.md)
3. [Remote PHP interpreter (Docker)](docs/remote-php-interpreter.md)
4. [Quality](docs/quality.md)
5. [Testing](docs/testing.md)
6. [Security](docs/security.md)
7. [Frontend](docs/frontend.md)
8. [Troubleshooting](docs/troubleshooting.md)

## Main resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/jprivet-dev/symfony-starter
- https://github.com/symfony/demo

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-sandbox/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-sandbox/blob/main/LICENSE).
