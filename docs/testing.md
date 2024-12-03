# Testing

⬅️ [README](../README.md)

## Types of Tests

| Types        | Description                                                                                                                                                                                         | Extends                                       |
|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------|
| Unit         | These tests ensure that _individual_ units of source code (e.g. a single class) behave as intended.                                                                                                 | TestCase                                      |
| Integration  | These tests test a combination of classes and commonly interact with Symfony's service container. These tests do not yet cover the fully working application, those are called _Application tests_. | KernelTestCase                                |
| Application  | Application tests test the behavior of a complete application. They make HTTP requests (both real and simulated ones) and test that the response is as expected.                                    | WebTestCase<br>ApiTestCase<br>PantherTestCase |

## Create a test

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

## the Arrange-Act-Assert (AAA) pattern

```php
class MyTest ... {
    function test() {
        // 1. Arrange
        // ... all necessary preconditions and inputs.

        // 2. Act
        // ... on the object or method under test.

        // 3. Assert
        // ... that the expected results have occurred.
    }
}
```

## Resources

- https://symfony.com/doc/current/testing.html
- https://pguso.medium.com/how-to-write-unit-tests-in-symfony-0a3cf12bcfd2
- https://stackoverflow.com/questions/9470795/using-the-arrange-act-assert-pattern-with-integration-tests
