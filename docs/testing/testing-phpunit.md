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
make functional NO_INTERACTION=true

# ... from specific folder
make functional ARG="tests/Functional/Application"

# ... from specific file
make functional ARG="tests/Functional/Application/MyTest.php"

# ... from specific method
make functional ARG="--filter testMyPage tests/Functional/Application/MyTest.php"
```

TIPS - To execute your complex commands more quickly, create an `t` alias:

```shell
alias t='make functional NO_INTERACTION=true ARG="--filter testMyPage tests/Functional/Application/MyTest.php"'

unalias t # Delete your alias
```

## Question: `$this->assertTrue()` or `self::assertTrue()` ?

* **There is no right way. And there is no wrong way, either.** It is a matter of personal preference.
* See https://docs.phpunit.de/en/10.5/assertions.html

## Troubleshooting: `You must set the KERNEL_CLASS environment variable`

Add in `phpunit.xml.dist`:

```
<php>
    <env name="KERNEL_CLASS" value="App\Kernel" />
</php>
```

## Resources

- https://phpunit.de/