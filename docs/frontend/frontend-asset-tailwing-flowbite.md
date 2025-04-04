# Frontend - Asset, Tailwind & Flowbite (No Node.js)

⬅️ [Frontend](../frontend.md)

## AssetMapper

The Symfony [AssetMapper](https://symfony.com/doc/current/frontend/asset_mapper.html) component lets you write modern JavaScript and CSS without the complexity of using a bundler.

### Installation

```shell
composer require symfony/asset
```

## Tailwind

[Tailwind](https://tailwindcss.com/) is a utility-first CSS framework packed with classes like `flex`, `pt-4`, `text-center` and `rotate-90` that can be composed to build any design, directly in your markup.

### Installation

```shell
composer require symfonycasts/tailwind-bundle
php bin/console tailwind:init
php bin/console tailwind:build
```

### How does it work with AssetMapper?

The first time you run one of the Tailwind commands, the bundle will download the correct [Tailwind binary](https://tailwindcss.com/blog/standalone-cli) for your system into a `var/tailwind/` directory.

Choose a binary version:

```yaml
# config/packages/symfonycasts_tailwind.yaml
symfonycasts_tailwind:
  binary_version: 'v3.4.*'
```

> If using Tailwind CSS v4+, `tailwind.config.js` is not created or used.

## Flowbite

[Flowbite](https://flowbite.com/) is an open source collection of UI components built with the utility classes from Tailwind CSS that you can use as a starting point when coding user interfaces and websites.

### Installation

```shell
php bin/console importmap:require flowbite
```

## Resources

- AssetMapper:
  - https://symfony.com/doc/current/frontend/asset_mapper.html
- Tailwind:
  - https://tailwindcss.com/
  - https://www.tailwindawesome.com/
  - https://github.com/timlrx/tailwind-nextjs-starter-blog
  - https://symfony.com/bundles/TailwindBundle/current/index.html
- Flowbite:
  - https://flowbite.com/
  - https://flowbite.com/docs/getting-started/symfony/
  - https://symfonycasts.com/screencast/last-stack/flowbite
  - https://github.com/themesberg/flowbite
