# Asset, Tailwind & Flowbite (No Node.js)

⬅️ [Frontend](../frontend.md)

## About

The Symfony [AssetMapper](https://symfony.com/doc/current/frontend/asset_mapper.html) component lets you write modern JavaScript and CSS without the complexity of using a bundler.

[Tailwind](https://tailwindcss.com/) is a utility-first CSS framework packed with classes like `flex`, `pt-4`, `text-center` and `rotate-90` that can be composed to build any design, directly in your markup.

[Flowbite](https://flowbite.com/) is an open source collection of UI components built with the utility classes from Tailwind CSS that you can use as a starting point when coding user interfaces and websites.

## Installation

Asset:

```
composer require symfony/asset
```

Tailwind:

```
composer require symfonycasts/tailwind-bundle
php bin/console tailwind:init
php bin/console tailwind:build
```

Flowbite:

```
php bin/console importmap:require flowbite
```

## Resources

- Asset:
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
