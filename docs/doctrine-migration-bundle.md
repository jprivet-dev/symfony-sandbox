# DoctrineMigrationsBundle

⬅️ [README](../README.md)

## About

Manage migrations.

## Installation

```
composer require doctrine/doctrine-migrations-bundle
```

## Main commands for the "doctrine" namespace

| Command                                      | Short                  | Description                                                                                             |
|----------------------------------------------|------------------------|---------------------------------------------------------------------------------------------------------|
| doctrine:schema:validate                     | d:s:v                  | Validate the mapping files                                                                              |
| doctrine:schema:update --dump-sql            | d:s:u --dump-sql       | Generate and output the SQL needed to synchronize the database schema with the current mapping metadata |
| doctrine:schema:update --force               | d:s:u --force          | Execute the generated SQL needed to synchronize the database schema with the current mapping metadata   |
| make:migration                               |                        | Create a new migration based on database changes                                                        |
| doctrine:migrations:migrate --all-or-nothing | d:m:m --all-or-nothing | Execute a migration to the latest available version (in a transaction)                                  |

## Migration Fails with doctrine:migrations:migrate

### Not null violation

```php
// Version20250512192333.php
public function up(Schema $schema): void
{
    $this->addSql('ALTER TABLE tag ADD slug VARCHAR(255) NOT NULL'); // <-- SQLSTATE[23502]: Not null violation
    $this->addSql('CREATE UNIQUE INDEX UNIQ_389B783989D9B62 ON tag (slug)');
}
```

> The problem is that my database already has tags.

#### Solution 1

Drop all and create database:

```shell
php bin/console doctrine:database:drop --force
php bin/console doctrine:database:create
```

Migrate:

```shell
php bin/console doctrine:migrations:migrate -n --all-or-nothing
```

And load fixtures:

```shell
php bin/console doctrine:fixtures:load
```

#### Solution 2

Update migration:

```php
// Version20250512192333.php
public function up(Schema $schema): void
{
    $this->addSql('ALTER TABLE tag ADD slug VARCHAR(255) DEFAULT NULL'); // Temporarily allow null values
    $this->addSql('UPDATE tag SET slug="temporary-not-null-value"');   // Set a default value

    $this->addSql('ALTER TABLE tag ADD slug VARCHAR(255) NOT NULL');     // Return to initial state
    $this->addSql('CREATE UNIQUE INDEX UNIQ_389B783989D9B62 ON tag (slug)');
}
```

Create a command that update all slugs of tags (use `TagRepository` and `SluggerInterface`):

```shell
php bin/console make:command app:tags-update-slug
```

Migrate:

```shell
php bin/console doctrine:migrations:migrate -n --all-or-nothing
```

And update all slugs:

```shell
php bin/console app:tags-update-slug
```

## Resources

- https://www.doctrine-project.org/
- https://symfony.com/bundles/DoctrineMigrationsBundle/current/index.html
- https://symfonycasts.com/screencast/symfony4-doctrine/failed-migrations