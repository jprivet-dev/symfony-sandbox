# Troubleshooting

⬅️ [README](../README.md)

## Error "address already in use" or "port is already allocated"

See [Troubleshooting on Symfony starter project](https://github.com/jprivet-dev/symfony-starter?tab=readme-ov-file#troubleshooting).

## Editing permissions on Linux

If you work on linux and cannot edit some of the project files right after the first installation, you can run in that project `make permissions`, to set yourself as owner of the project files that were created by the docker container.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md

## doctrine:schema:validate returns DROP TABLE doctrine_migration_versions

I have the same problem as this issue https://github.com/doctrine/migrations/issues/1406:

```
php php bin/console doctrine:schema:validate

Mapping
-------

 [OK] The mapping files are correct.

Database
--------

 [ERROR] The database schema is not in sync with the current mapping file.

 // 1 schema diff(s) detected:

     DROP TABLE doctrine_migration_versions;
```

No solution has yet been found...