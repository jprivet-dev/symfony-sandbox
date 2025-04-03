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

### 1 - Clone the project

```shell
git clone git@github.com:jprivet-dev/symfony-sandbox.git
cd symfony-sandbox
```

### 2 - Build fresh images and start the containers

```shell
make build upd
```

### 3 - Install all

Install dependencies, generate assets, execute the migration, init git hooks and show info:

```shell
make install
```

### 4 - Go on the app

Open https://symfony-sandbox.localhost/ and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334).

### All in one

```shell
git clone git@github.com:jprivet-dev/symfony-sandbox.git && cd symfony-sandbox && make build upd install
```

### Then with Makefile...

```shell
make start # Start the project and show info (upd & info alias)
make stop  # Stop the project (down alias)
```

> Run `make` to see all shorcuts for the most common tasks.

## Docs

- [Frontend](docs/frontend.md)
- [Makefile: use Docker build options](docs/makefile.md)
- [PostgreSQL](docs/postgre.md)
- [Quality](docs/quality.md)
- [Remote PHP interpreter (Docker) with your IDE](docs/remote-php-interpreter-ide.md)
- [Security](docs/security.md)
- [Testing](docs/testing.md)
- [Troubleshooting](docs/troubleshooting.md)
- [dunglas/symfony-docker](docs/dunglas-symfony-docker.md)

## Main resources

- https://symfony.com/doc/current/setup/docker.html
- https://github.com/dunglas/symfony-docker
- https://github.com/jprivet-dev/symfony-starter
- https://github.com/symfony/demo

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-sandbox/issues).

## License

This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-sandbox/blob/main/LICENSE).
