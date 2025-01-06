# Security

⬅️ [README](../README.md)

## About

The SecurityBundle provides all authentication and authorization features needed to secure your application.

## Installation

```
composer require symfony/security-bundle
composer require symfony/uid
```

## Create an user with UUID

```
php bin/console make:user --with-uuid

 The name of the security user class (e.g. User) [User]:
 > User

 Do you want to store user data in the database (via Doctrine)? (yes/no) [yes]:
 > yes

 Enter a property name that will be the unique "display" name for the user (e.g. email, username, uuid) [email]:
 > email

 Will this app need to hash/check user passwords? Choose No if passwords are not needed or will be checked/hashed by some other system (e.g. a single sign-on server).

 Does this app need to hash/check user passwords? (yes/no) [yes]:
 > yes

 created: src/Entity/User.php
 created: src/Repository/UserRepository.php
 updated: src/Entity/User.php
 updated: config/packages/security.yaml
```

Don't forget to create the tables by creating and running a migration:

```
php bin/console make:migration
php bin/console doctrine:migrations:migrate
```

### Troubleshooting: `doctrine.uuid_generator` vs `UuidGenerator::class`

With:

```php 
class User implements UserInterface, PasswordAuthenticatedUserInterface
{
    ...
    #[ORM\CustomIdGenerator(class: 'doctrine.uuid_generator')]
    private ?Uuid $id = null;
    ...
```

PHPStan analyse generate the following error:

```
     Internal error: Cannot instantiate custom generator : array (           
       'class' => 'doctrine.uuid_generator',                                 
     ) while analysing file /app/src/Entity/User.php   
```

Use `UuidGenerator::class` instead:

```php 
class User implements UserInterface, PasswordAuthenticatedUserInterface
{
    ...
    #[ORM\CustomIdGenerator(class: UuidGenerator::class)]
    private ?Uuid $id = null;
    ...
```

> See https://github.com/phpstan/phpstan-doctrine/issues/297#issuecomment-1211838441

## Create the form login authenticator

- Generate the code:

```
php bin/console make:security:form-login
```
- Activate [remember me functionality](https://symfony.com/doc/current/security/remember_me.html).
- Use [Authentication-form Flowbite component](https://flowbite.com/docs/components/jumbotron/#authentication-form).

## Resources

- https://symfony.com/doc/current/security.html