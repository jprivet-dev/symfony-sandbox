# PostgreSQL

⬅️ [Configure PhpStorm & VS Code](../configure.md)

## About

PostgreSQL is an object-relational database management system (ORDMBS), which means that it has relational capabilities and an object-oriented design.

## PhpStorm

- In the **Database** tool window (**View > Tool Windows > Database**), click on `+` in the toolbar.
- Navigate to **Data Source** and select **PostgreSQL**.
- In the **General** tab of **Data Sources and Drivers** dialog right pane:
    - Specify:
        - Host: `127.0.0.0`.
        - Port: `5432`.
        - User: `app`.
        - Password: `!ChangeMe!` (it still be hidden).
        - Database: `app`.
    - Click on **Test Connection**: if all goes well, you will see the **Succeeded** message.
    - Click on `OK` or `Apply` to validate all.

![phpstorm-data-sources-and-drivers-postgresql.png](..%2Fimg%2Fphpstorm-data-sources-and-drivers-postgresql.png)

## VS Code

TODO

## Resources

- https://www.postgresql.org/
- https://aws.amazon.com/fr/rds/postgresql/what-is-postgresql
- https://www.jetbrains.com/help/phpstorm/postgresql.html