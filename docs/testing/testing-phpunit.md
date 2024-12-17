# Testing - PHPUnit

⬅️ [Testing](../testing.md)

## About

PHPUnit is a programmer-oriented testing framework for PHP. It is an instance of the xUnit architecture for unit testing frameworks.

## Installation

```
composer require --dev symfony/test-pack
```

## Configure your IDE

- [Testing - Configure PhpStorm](testing-phpunit-phpstorm.md)
- [Testing - Configure VS Code](testing-phpunit-vscode.md)

## Makefile

> Run `make` to see all shorcuts for the most common tasks.

Examples :

```shell
# Run all functional tests...
make functional

# ... without interaction [Yes/No]
make functional no_interaction=true

# ... without database init and fixtures
make functional no_fixtures=true

# ... from specific folder
make functional f="tests/Functional/Application"

# ... from specific file
make functional f="tests/Functional/Application/MyTest.php"

# ... from specific method
make functional f="--filter testMyPage tests/Functional/Application/MyTest.php"
```

TIPS - To execute your complex commands more quickly, create an `t` alias:

```shell
alias t='make functional no_interaction=true no_fixtures=true f="--filter testMyPage tests/Functional/Application/MyTest.php"'

unalias t # Delete your alias
```

## Resources

- https://phpunit.de/