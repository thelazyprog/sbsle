# Spring Boot structured like Elixir

This project is the base source code for a project that was forced to use Java, with an Elixir-like project structure as just a silent protest I did not have to.

## Software stack

- Java11
- MySQL 8+
- Spring Boot 2.5.6
- Bootstrap 5+

## Directory structure


- `_build` - a directory created by the gradle command line tool that holds all compilation artifacts. This directory must not be checked into version control and it can be removed at any time.
- `apps` - a directory for Java application projects.
- `priv` - a directory that keeps all resources that are necessary in production but are not directly part of source code. Typically keep database scripts, translation files, and more in here. Static and generated assets, sourced from the assets directory, are also served from here by default.
- `lib` - a directory that holds the application source code. This directory is broken into two subdirectories, `lib/*my_awesome_app*` and `lib/*my_awesome_app_*web`. The l`ib/*my_awesome_app*` directory will be responsible to host all of business logic and business domain. It typically interacts directly with the database - it is the "Model" in Model-View-Controller (MVC) architecture. `lib/*my_awesome_app_*web` is responsible for exposing business domain to the world, in this case, through a web application. It holds both the View and Controller from MVC.
- `assets` - a directory that keeps everything related to source front-end assets, such as JavaScript and CSS, and automatically managed by the esbuild tool.
- `test` - a directory with all of our application tests. It often mirrors the same structure found in `lib`.

## Local environment

### Tools should be installed

- Git 2.31+
- Gradle 7.1+

### Environment variables

| name                | value example   |
| ------------------- | --------------- |
| SBSLE_APP_PORT      | 8080            |
| SBSLE_DB_HOST       | localhost       |
| SBSLE_DB_PORT       | 3306            |
| SBSLE_DB_NAME       | sbsle           |
| SBSLE_DB_USER       | sbsle_user      |
| SBSLE_DB_PASS       | password        |
| SBSLE_APP_LOG_DIR   | /var/log/sbsle  |
| SBSLE_APP_PROC_OWN  | tomcat          |

### MySQL
#### User account

```sh
mysql> CREATE USER user_name@localhost IDENTIFIED BY 'password';
mysql> CREATE DATABASE database_name;
mysql> GRANT ALL PRIVILEGES ON database_name.* TO 'user_name'@'localhost';

```

#### Migration

```sh
$ ./sbsle migrate
```

### Run apps

```sh
$ ./sbsle run
```

Yeah I know, just error if access the server. No wonder, since controller is not implemented. But app do run with this directory structure. In this project, that's enough, right? Cuz this project name also means "Supplied By a Super Lazy Editor".
