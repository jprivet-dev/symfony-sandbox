# Testing

⬅️ [README](../README.md)

## Types of Tests

| Types       | Description                                                                                                                                                                                         | Extends                                      |
|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| Unit        | These tests ensure that _individual_ units of source code (e.g. a single class) behave as intended.                                                                                                 | TestCase                                     |
| Functional    | Functional tests encompasse **Integration** and **Application** tests.                                                                                                                                  |                                |
| Integration | These tests test a combination of classes and commonly interact with **Symfony's service container**. These tests do not yet cover the fully working application, those are called _Application tests_. | KernelTestCase                               |
| Application | Application tests test the behavior of a complete application. **They make HTTP requests** (both real and simulated ones) and test that the response is as expected.                                    | WebTestCase<br>ApiTestCase<br>PantherTestCase |

## Create a test with Symfony

```
php bin/console make:test

 Which test type would you like?:
  [TestCase       ] basic PHPUnit tests
  [KernelTestCase ] basic tests that have access to Symfony services
  [WebTestCase    ] to run browser-like scenarios, but that don't execute JavaScript code
  [ApiTestCase    ] to run API-oriented scenarios
  [PantherTestCase] to run e2e scenarios, using a real-browser or HTTP client and a real web server
  >
```

## The Arrange-Act-Assert (AAA) pattern

```php
class MyTest ... {
    function test() {
        // 1. ARRANGE all necessary preconditions and inputs

        // 2. ACT on the object or method under test

        // 3. ASSERT that the expected results have occurred
    }
}
```

## Smoke testing

In software engineering, [smoke testing](https://en.wikipedia.org/wiki/Smoke_testing_(software)) consists of "_preliminary testing to reveal simple failures severe enough to reject a prospective software release_". Using [PHPUnit data providers](https://docs.phpunit.de/en/9.6/writing-tests-for-phpunit.html#data-providers) you can define a functional test that checks that all application URLs load successfully.

> Example : [tests/Application/SmokeTest.php](../tests/Application/SmokeTest.php)

## Launch specific tests

### In PhpStorm and VS Code

You need to configure [PHPUnit](configure/configure-phpunit.md).

### With commands

> Run `make` to see all shorcuts for the most common tasks.

With `make`:

```shell
# All tests
make phpunit

# Unit tests
make phpunit p="--testsuite unit"

# All tests in a folder
make phpunit p="--filter tests/MyFolder"

# All tests in a class
make phpunit p="--filter tests/MyFolder/MyTest.php"

# A specific method
make phpunit p="--filter testMyService tests/MyFolder/MyTest.php"
```

With `. aliases`:

```shell
# All tests
phpunit

# Unit tests
phpunit --testsuite unit

# All tests in a folder
phpunit --filter tests/MyFolder

# All tests in a class
phpunit --filter tests/MyFolder/MyTest.php

# A specific method
phpunit --filter testMyService tests/MyFolder/MyTest.php
```

TIPS - To execute your complex commands more quickly, create an alias:

```shell
# With make
alias t='make phpunit p="--filter testMyService tests/MyFolder/MyTest.php"'

# With `. aliases`
alias t='phpunit --filter testMyService tests/MyFolder/MyTest.php'

# Delete your alias
unalias t
```

## Resources

- https://symfony.com/doc/current/testing.html
- https://pguso.medium.com/how-to-write-unit-tests-in-symfony-0a3cf12bcfd2
- https://stackoverflow.com/questions/9470795/using-the-arrange-act-assert-pattern-with-integration-tests
- https://symfony.com/doc/current/best_practices.html#smoke-test-your-urls
- https://github.com/shopsys/http-smoke-testing
