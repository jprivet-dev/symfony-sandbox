# Frontend - Symfony UX

⬅️ [Frontend](../frontend.md)

## About

A set of PHP & JavaScript packages to solve every day frontend problems featuring Stimulus and Turbo.

Resources:

- https://ux.symfony.com/

## Twig

Install:

```
composer require symfony/twig-bundle
composer require twig/intl-extra
composer require twig/extra-bundle
```

Resources:

- https://twig.symfony.com/

## Asset Mapper & Stimulus

Install:

```
composer require symfony/asset-mapper symfony/stimulus-bundle
```

## Live Components

Install:

```
composer require symfony/ux-live-component
```

Resources:

- https://ux.symfony.com/live-component

## Swup

Versatile and extensible page transition library for server-rendered websites.

Install:

```
composer require symfony/ux-swup
```

Configuration:

```twig
<html lang="en">
    <head>
        <title>Swup</title>

        {% block javascripts %}
            {% block importmap %}{{ importmap('app') }}{% endblock %}
        {% endblock %}
    </head>
    <body
        {{ stimulus_controller('symfony/ux-swup/swup', {
            containers: ['main']
        }) }}
    >
        <main>
            {# ... #}
        </main>
    </body>
</html>
```

Install `SwupFragmentPlugin` & `FragmentPlugin`:

```
php bin/console importmap:require @swup/fragment-plugin
php bin/console importmap:require @swup/preload-plugin
```

Resources:

- https://symfony.com/bundles/ux-swup/current/index.html
- https://swup.js.org/
- https://swup.js.org/getting-started/demos/#multiple-animations
- https://swup.js.org/plugins/fragment-plugin/
