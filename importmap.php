<?php

/**
 * Returns the importmap for this application.
 *
 * - "path" is a path inside the asset mapper system. Use the
 *     "debug:asset-map" command to see the full list of paths.
 *
 * - "entrypoint" (JavaScript only) set to true for any module that will
 *     be used as an "entrypoint" (and passed to the importmap() Twig function).
 *
 * The "importmap:require" command can be used to add new entries to this file.
 */
return [
    'app' => [
        'path' => './assets/app.js',
        'entrypoint' => true,
    ],
    '@symfony/stimulus-bundle' => [
        'path' => './vendor/symfony/stimulus-bundle/assets/dist/loader.js',
    ],
    '@symfony/ux-live-component' => [
        'path' => './vendor/symfony/ux-live-component/assets/dist/live_controller.js',
    ],
    '@hotwired/stimulus' => [
        'version' => '3.2.2',
    ],
    'flowbite' => [
        'version' => '3.1.2',
    ],
    '@popperjs/core' => [
        'version' => '2.11.8',
    ],
    'flowbite-datepicker' => [
        'version' => '1.3.2',
    ],
    'flowbite/dist/flowbite.min.css' => [
        'version' => '3.1.2',
        'type' => 'css',
    ],
    '@swup/fade-theme' => [
        'version' => '1.0.5',
    ],
    '@swup/slide-theme' => [
        'version' => '1.0.5',
    ],
    '@swup/forms-plugin' => [
        'version' => '2.0.1',
    ],
    '@swup/plugin' => [
        'version' => '2.0.2',
    ],
    'swup' => [
        'version' => '3.1.1',
    ],
    'delegate-it' => [
        'version' => '6.0.1',
    ],
    '@swup/debug-plugin' => [
        'version' => '3.0.0',
    ],
    '@swup/theme' => [
        'version' => '2.1.0',
    ],
    'path-to-regexp' => [
        'version' => '6.3.0',
    ],
    '@swup/fragment-plugin' => [
        'version' => '1.1.1',
    ],
];
