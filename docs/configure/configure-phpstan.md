# PHPStan

⬅️ [Configure PhpStorm & VS Code](../configure.md)

## About

PHPStan scans your whole codebase and looks for both obvious & tricky bugs.

## Installation

```
composer require --dev phpstan/phpstan
Do you want to execute this recipe?
...
(defaults to n): y
```

## PhpStorm

- Go on **Settings (Ctrl+Alt+S) > PHP > Quality Tools**.
- Expand the **PHPStan** area and switch `ON` the tool.
- In **Configuration**, choose **app-php:latest**.
- In **Options** area:
    - Level: `6`.
    - Configuration file: choose the `phpstan.dist.neon` file of this repository.
- In the **Settings** dialog, click on `OK` or `Apply` to validate all.

![phpstorm-settings-php-quality-tools-phpstan.png](../img/phpstorm-settings-php-quality-tools-phpstan.png)

## VS Code

TODO

## Resources

- https://phpstan.org/
- https://packagist.org/packages/phpstan/phpstan-doctrine
