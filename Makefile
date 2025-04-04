#
# COLORS
#

# (G)REEN, (R)ED, (Y)ELLOW & RE(S)ET
G = "\\033[32m"
R = "\\033[31m"
Y = "\\033[33m"
S = "\\033[0m"

#
# USER
#

USER_ID  = $(shell id -u)
GROUP_ID = $(shell id -g)
USER     = $(USER_ID):$(GROUP_ID)

#
# SYMFONY ENVIRONMENT VARIABLES
#

# Files in order of increasing priority.
# @see https://github.com/jprivet-dev/makefiles/tree/main/symfony-env-include
# @see https://www.gnu.org/software/make/manual/html_node/Environment.html
# @see https://github.com/symfony/recipes/issues/18
# @see https://symfony.com/doc/current/quick_tour/the_architecture.html#environment-variables
# @see https://symfony.com/doc/current/configuration.html#listing-environment-variables
# @see https://symfony.com/doc/current/configuration.html#overriding-environment-values-via-env-local
-include .env
-include .env.local

# get APP_ENV original value
FILE_ENV := $(APP_ENV)
-include .env.$(FILE_ENV)
-include .env.$(FILE_ENV).local

ifneq ($(FILE_ENV),$(APP_ENV))
$(info Warning: APP_ENV is overloaded outside .env and .env.local files)
endif

ifeq ($(FILE_ENV),prod)
$(info Warning: Your are in the prod environment)
else ifeq ($(FILE_ENV),test)
$(info Warning: Your are in the test environment)
endif

# @see https://symfony.com/doc/current/deployment.html#b-configure-your-environment-variables
ifneq ($(wildcard .env.local.php),)
$(info Warning: It is not possible to use variables from .env.local.php file)
$(info Warning: The final APP_ENV of that Makefile may be different from the APP_ENV of .env.local.php)
endif

#
# FILES & DIRECTORIES
#

PWD               = $(shell pwd)
NOW               = $(shell date +%Y%m%d-%H%M)
PHPMETRICS_DIR    = src
PHPMETRICS_REPORT = build/phpmetrics-report-$(NOW)
PHPMETRICS_INDEX  = $(PWD)/$(PHPMETRICS_REPORT)/index.html
PHPMD_DIR         = bin,config,public,src
PHPSTAN_DIR       = src
PHPSTAN_CONFIG    = phpstan.dist.neon
PHPSTAN_BASELINE  = phpstan-baseline.php
XDEBUG_INI        = /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COVERAGE_DIR      = build/coverage-$(NOW)
COVERAGE_INDEX    = $(PWD)/$(COVERAGE_DIR)/index.html
PHPCSFIXER_CONFIG = .php-cs-fixer.dist.php
TWIGCSFIXER_DIR   = templates
TAILWIND_CONFIG   = tailwind.config.js

#
# OPTIONS
# https://github.com/dunglas/symfony-docker/blob/main/docs/options.md
#

PROJECT_NAME    ?= $(shell basename $(CURDIR))
SERVER_NAME     ?= $(PROJECT_NAME).localhost
UP_ENV          ?=

ifneq ($(FILE_ENV),prod)
XDEBUG_MODE = coverage
endif

ifneq ($(XDEBUG_MODE),)
UP_ENV += XDEBUG_MODE=$(XDEBUG_MODE)
endif

ifneq ($(SERVER_NAME),)
UP_ENV += SERVER_NAME=$(SERVER_NAME)
endif

ifneq ($(SYMFONY_VERSION),)
UP_ENV += SYMFONY_VERSION=$(SYMFONY_VERSION)
endif

ifneq ($(STABILITY),)
UP_ENV += STABILITY=$(STABILITY)
endif

ifneq ($(HTTP_PORT),)
UP_ENV += HTTP_PORT=$(HTTP_PORT)
endif

ifneq ($(HTTPS_PORT),)
UP_ENV += HTTPS_PORT=$(HTTPS_PORT)
endif

ifneq ($(HTTP3_PORT),)
UP_ENV += HTTP3_PORT=$(HTTP3_PORT)
endif

#
# DOCKER
#

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(error Docker Compose CLI plugin is required but is not available on your system)
endif

COMPOSE = docker compose

ifeq ($(FILE_ENV),prod)
COMPOSE = $(COMPOSE) -f compose.yaml -f compose.prod.yaml
endif

# -T : avoid "the input device is not a TTY" error - Example: $ NO_TTY=true make my_command
NO_TTY ?= false
ifeq ($(NO_TTY), true)
EXEC = $(COMPOSE) exec -T
else
EXEC = $(COMPOSE) exec
endif

CONTAINER_PHP      = $(EXEC) php
CONTAINER_DB       = $(EXEC) database
PHP                = $(CONTAINER_PHP) php
COMPOSER           = $(CONTAINER_PHP) composer
DB                 = $(CONTAINER_PHP) database
PSQL               = $(CONTAINER_DB) psql
CONSOLE            = $(PHP) bin/console
PHPMETRICS         = $(PHP) vendor/bin/phpmetrics
PHPCSFIXER         = $(PHP) vendor/bin/php-cs-fixer
PHPMD              = $(PHP) vendor/bin/phpmd
PHPSTAN            = $(PHP) vendor/bin/phpstan
PHPUNIT            = $(PHP) vendor/bin/phpunit
TWIGCSFIXER        = $(PHP) vendor/bin/twig-cs-fixer

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

# Print self-documented Makefile:
# $ make
# $ make help

.DEFAULT_GOAL = help
.PHONY: help
help: ## Print self-documented Makefile
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' Makefile | awk 'BEGIN {FS = "## "}; { \
		split($$1, line, ":"); targets=line[1]; description=$$2; \
		if (targets == "##") { \
			printf "\033[33m%s\n", ""; # space \
		} else if (targets == "" && description != "") { \
			printf "\033[33m\n%s\n", description; # title \
		} else if (targets != "" && description != "") { \
			split(targets, parts, " "); target=parts[1]; alias=parts[2]; \
			printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; # target alias: description \
		} \
	}'
	@echo

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: start
start: upd info ## Start the project and show info (upd & info alias)

.PHONY: stop
stop: down ## Stop the project (down alias)

.PHONY: install
install: composer_install assets migrate git_hooks_on info ## Install dependencies, generate assets, execute the migration, init git hooks and show info

##

.PHONY: check
check: confirm importmap_audit composer_validate lint tests ## Check everything before you deliver [y/N]

PHONY: info
info: ## Show info
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "* Run $(Y). aliases$(S) to load all the project aliases.\n"
	@printf "* Go on $(G)https://$(SERVER_NAME)/$(S)\n"
	@printf "\n"

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony - $ make symfony [ARG=<arguments>] - Example: $ make symfony ARG=--help
	$(CONSOLE) $(ARG)

.PHONY: cc
cc: ## Clear the cache
	$(CONSOLE) cache:clear

.PHONY: about
about: ## Display information about the current project
	$(CONSOLE) about

.PHONY: dotenv
dotenv: ## Lists all dotenv files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php
	$(COMPOSER) dump-env prod

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer - $ make composer [ARG=<arguments>] - Example: $ make composer ARG="require --dev phpunit/phpunit"
	$(COMPOSER) $(ARG)

composer_validate: ## Validate composer.json and composer.lock
	$(COMPOSER) validate --strict --check-lock

##

composer_install: ## Install packages using composer
	$(COMPOSER) install

composer_install@prod: ## Install packages using composer (env=prod)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

composer_update: ## Update packages using composer
	$(COMPOSER) update

composer_update@prod: ## Update packages using composer (env=prod)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

##

composer_clean: confirm ## Remove vendor/ [y/N]
	rm -rf vendor

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP - $ make php [ARG=<arguments>]- Example: $ make php ARG=--version
	$(PHP) $(ARG)

php_sh: ## Connect to the PHP container
	$(CONTAINER_PHP) sh

php_modules: ## Show compiled in modules
	$(PHP) -m

## — DOCTRINE & SQL 💽 ————————————————————————————————————————————————————————

.PHONY: db
db: confirm db_drop db_create migrate ## Drop and create the database and migrate [y/N]

db@test: ARG="--env=test"
db@test: db ## Drop and create the database and migrate (env=test) [y/N]

db_drop: confirm ## Drop the database [y/N] - $ make db_drop [ARG=<arguments>] - Example: $ make db_drop ARG="--env=test" [y/N]
	$(CONSOLE) doctrine:database:drop --if-exists --force $(ARG)

db_create: confirm ## Create the database [y/N] - $ make db_create [ARG=<arguments>] - Example: $ make db_create ARG="--env=test" [y/N]
	$(CONSOLE) doctrine:database:create --if-not-exists $(ARG)

##

.PHONY: validate
validate: ## Validate the mapping files - $ make validate [ARG=<arguments>] - Example: $ make validate ARG="--env=test"
	-$(CONSOLE) doctrine:schema:validate -v $(ARG)

update_dump_sql: ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

update_force: ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

##

.PHONY: migration
migration: ## Create a new migration based on database changes
	$(CONSOLE) make:migration $(ARG)

.PHONY: migrate
migrate: ## Execute a migration to the latest available version - $ make migrate [ARG=<param>] - Example: $ make migrate ARG="current+3"
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(ARG)

migrate@test: ARG="--env=test"
migrate@test: migrate ## Execute a migration to the latest available version (env=test)

.PHONY: list
list: ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: execute
execute: ## Execute one or more migration versions up or down manually - $ make execute ARG=<arguments> - Example: $ make execute ARG="DoctrineMigrations\Version20240205143239"
	$(CONSOLE) doctrine:migrations:execute $(ARG)

.PHONY: generate
generate: ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

##

.PHONY: fixtures
fixtures: confirm ## Load fixtures (CAUTION! by default the load command purges the database) [y/N] - $ make fixtures [ARG=<param>] - Example: $ make fixtures ARG="--append" [y/N]
	$(CONSOLE) doctrine:fixtures:load -n $(ARG)

fixtures@test: ARG="--env=test"
fixtures@test: confirm fixtures ## Load fixtures (env=test) [y/N]

##

.PHONY: sql
sql: ## Execute the given SQL query and output the results - $ make sql [QUERY=<query>] [ARG=<arguments>] - Example: $ make sql QUERY="SELECT * FROM user"
	$(CONSOLE) doctrine:query:sql "$(QUERY)" $(ARG)

sql@test: ARG="--env=test"
sql@test: sql ## Execute the given SQL query and output the results (env=test)

##

# @see https://stackoverflow.com/questions/769683/how-to-show-tables-in-postgresql
sql_tables: ## Show all tables
	$(MAKE) -s sql QUERY="SELECT * FROM pg_catalog.pg_tables;" $(ARG)

sql_tables@test: ARG="--env=test"
sql_tables@test: sql_tables ## Show all tables (env=test)

## — POSTGRESQL 💽 ————————————————————————————————————————————————————————————

.PHONY: psql
psql: ## Execute psql - $ make psql [ARG=<arguments>] - Example: $ make psql ARG="-V"
	$(PSQL) $(ARG)

## — TESTS ✅ —————————————————————————————————————————————————————————————————

.PHONY: phpunit
phpunit: ## Run PHPUnit - $ make phpunit [ARG=<arguments>] - Example: $ make phpunit ARG="tests/myTest.php"
	$(PHPUNIT) $(ARG)

##

.PHONY: tests
tests: confirm _functional_setup phpunit ## Run all tests [y/N]

PHONY: coverage
coverage: ARG=--coverage-html $(COVERAGE_DIR)
coverage: tests _print_coverage_path ## Generate code coverage report in HTML format for all tests [y/N]

_print_coverage_path: # INTERNAL
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(COVERAGE_INDEX)$(S)\n"

.PHONY: dox
dox: ARG=--testdox
dox: tests ## Report test execution progress in TestDox format for all tests [y/N]

##

.PHONY: unit
unit: confirm ## Run unit tests [y/N]
	$(PHPUNIT) --testsuite unit $(ARG)

unit_coverage: ARG=--coverage-html $(COVERAGE_DIR)
unit_coverage: unit _print_coverage_path ## Generate code coverage report in HTML format for unit tests [y/N]

unit_dox: ARG=--testdox
unit_dox: unit ## Report test execution progress in TestDox format for unit tests [y/N]

##

.PHONY: functional
functional: _functional_setup ## Run functional tests [y/N]
	$(PHPUNIT) --testsuite application,integration $(ARG)

functional_coverage: ARG=--coverage-html $(COVERAGE_DIR)
functional_coverage: functional _print_coverage_path ## Generate code coverage report in HTML format for functional tests [y/N]

functional_dox: ARG=--testdox
functional_dox: functional ## Report test execution progress in TestDox format for functional tests [y/N]

_functional_setup: confirm db@test fixtures@test # INTERNAL: Setup before launch functional tests (database init & fixtures) [y/N]

##

.PHONY: application
application: _functional_setup ## Run application tests [y/N]
	$(PHPUNIT) --testsuite application $(ARG)

.PHONY: integration
integration: _functional_setup ## Run integration tests [y/N]
	$(PHPUNIT) --testsuite integration $(ARG)

##

xdebug_version: ## Xdebug version number
	$(PHP) -r "var_dump(phpversion('xdebug'));"

## — QUALITY ✅ ———————————————————————————————————————————————————————————————

.PHONY: phpmetrics
phpmetrics: ## Run PhpMetrics - $ make phpmetrics [ARG=<arguments>] - Example: $ make phpmetrics ARG=--help
	$(PHPMETRICS) $(ARG)

phpmetrics_report: confirm ## Generate the PhpMetrics HTML report
	$(PHPMETRICS) --report-html="$(PHPMETRICS_REPORT)" $(PHPMETRICS_DIR)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(PHPMETRICS_INDEX)$(S)\n"

##

.PHONY: phpmd
phpmd: ## Run PHP Mess Detector - $ make phpmd [ARG=<arguments>] - Example: $ make phpmd ARG=src/Kernel.php
	$(PHPMD) $(ARG) $(PHPMD_DIR) ansi phpmd.xml

.PHONY: phpstan
phpstan: ## Run PHPStan - $ make phpstan [ARG=<arguments>] - Example: $ make phpstan ARG="src tests"
	$(PHPSTAN) $(ARG)

phpstan_analyse: ## Run PHPStan analyse - $ make phpstan_analyse [ARG=<arguments>] - Example: $ make phpstan_analyse ARG="src tests"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(ARG)

phpstan_baseline: ## Generate PHPStan baseline - $ make phpstan_baseline [ARG=<arguments>] - Example: $ make phpstan_baseline ARG="src tests"
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(ARG) --generate-baseline $(PHPSTAN_BASELINE)

##

.PHONY: phpcsfixer
phpcsfixer: ## Run PHP CS Fixer - $ make phpcsfixer [ARG=<arguments>] - Example: $ make phpcsfixer ARG=list
	$(PHPCSFIXER) $(ARG)

phpcsfixer_check: ## Check code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) check -v

phpcsfixer_fix: ## Fix code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) fix

##

.PHONY: twigcsfixer
twigcsfixer: ## Run Twig CS Fixer - $ make twigcsfixer [ARG=<arguments>] - Example: $ make twigcsfixer ARG=--help
	$(TWIGCSFIXER) $(ARG)

twigcsfixer_lint: ## Check code style
	$(TWIGCSFIXER) lint $(TWIGCSFIXER_DIR)

twigcsfixer_fix: ## Fix code style
	$(TWIGCSFIXER) lint --fix $(TWIGCSFIXER_DIR)

##

.PHONY: lint
lint: confirm phpmd phpcsfixer_check phpstan_analyse twigcsfixer_lint ## Run all linters [y/N]

.PHONY: fix
fix: confirm phpcsfixer_fix twigcsfixer_fix ## Fix with all linters [y/N]

## — ASSETS 🎨‍ ————————————————————————————————————————————————————————————————

.PHONY: assets
assets: importmap_install tailwind_build ## Generate all assets.

assets@prod: asset_compile tailwind_minify ## Deploy all assets.

##

asset_compile: ## Compile all mapped assets and writes them to the final public output directory.
	$(CONSOLE) asset-map:compile

asset_debug: ## See all of the mapped assets .
	$(CONSOLE) debug:asset-map --full

##

importmap_audit: ## Check for security vulnerability advisories for dependencies
	$(CONSOLE) importmap:audit

importmap_install: ## Download all assets that should be downloaded
	$(CONSOLE) importmap:install

importmap_outdated: ## List outdated JavaScript packages and their latest versions
	$(CONSOLE) importmap:outdated

importmap_remove: ## Remove JavaScript packages
	$(CONSOLE) importmap:remove

importmap_require: ## Require JavaScript packages
	$(CONSOLE) importmap:require

importmap_update: ## Update JavaScript packages to their latest versions
	$(CONSOLE) importmap:update

##

tailwind_build: ## Build the Tailwind CSS assets - $ make tailwind_build [ARG=<arguments>] - Example: $ make tailwind_build ARG=--help
	$(CONSOLE) tailwind:build -v $(ARG)

tailwind_watch w: ARG=--watch
tailwind_watch w: tailwind_build ## Watch for changes and rebuild automatically.

tailwind_minify: ARG=--minify
tailwind_minify: tailwind_build ## Minify the output CSS.

tailwind_debug: ## See the full config from TailwindBundle
	$(CONSOLE) config:dump symfonycasts_tailwind

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: compose
compose: ## Execute compose with default options - $ make compose [ARG=<arguments>] - Example: $ make compose ARG=--help
	$(COMPOSE) $(ARG)

.PHONY: up
up: ## Start the containers - $ make up [ARG=<arguments>] - Example: $ make up ARG=-d
	$(UP_ENV) $(COMPOSE) up --remove-orphans --pull always $(ARG)

.PHONY: upd
upd: ARG=--wait -d
upd: up ## Start the containers (wait for services to be running|healthy - detached mode)

.PHONY: down
down: ## Stop the containers
	$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild services - $ make build [ARG=<arguments>] - Example: $ make build ARG=--no-cache
	$(COMPOSE) build --pull $(ARG)

.PHONY: logs
logs: ## View output from containers
	$(COMPOSE) logs

.PHONY: config
config: ## Parse, resolve and render compose file in canonical format
	$(COMPOSE) config

## — GIT 🐙 ———————————————————————————————————————————————————————————————————

git_hooks_on on: ## Use the hooks directory of this project
	git config core.hooksPath hooks/

git_hooks_off of: ## Use the default hooks directory of Git
	git config --unset core.hooksPath

git_pre_push: check ## Actions on pre-push

## — TROUBLESHOOTING 😵‍️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions p: ## Run it if you cannot edit some of the project files on Linux
	$(COMPOSE) run --rm php chown -R $(USER) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER)$(S) of the project files.\n"

## — UTILS 🛠️  —————————————————————————————————————————————————————————————————

.PHONY: vars
vars: ## Show some Makefile variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "USER      : $(USER)\n"
	@printf "FILE_ENV  : $(FILE_ENV)\n"
	@printf "APP_ENV   : $(APP_ENV)\n"
	@printf "APP_SECRET: $(APP_SECRET)\n"
	@printf "UP_ENV    : $(UP_ENV)\n"
	@printf "COMPOSE_V2: $(COMPOSE_V2)\n"
	@printf "COMPOSE   : $(COMPOSE)\n"

## — INTERNAL 🚧‍️ ——————————————————————————————————————————————————————————————

confirm: ## Display a confirmation before continuing [y/N]
	@$(eval no_interaction ?=) # Interactive question or not
	@if [ "$${no_interaction}" = "true" ]; then exit 0; fi; \
	printf "$(G)Do you want to continue?$(S) [$(Y)y/N$(S)]: " && read answer && [ $${answer:-N} = y ]
