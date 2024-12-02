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

#
# OVERLOADING
#

-include overload/.env

PROJECT_NAME           ?= $(shell basename $(CURDIR))
COMPOSE_BUILD_OPTS     ?=
COMPOSE_UP_SERVER_NAME ?= $(PROJECT_NAME).localhost
COMPOSE_UP_ENV_BASE    ?= XDEBUG_MODE=coverage SERVER_NAME=$(COMPOSE_UP_SERVER_NAME)
COMPOSE_UP_ENV_VARS    ?=

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
# DOCKER
#

COMPOSE_V2 := $(shell docker compose version 2> /dev/null)

ifndef COMPOSE_V2
$(error Docker Compose CLI plugin is required but is not available on your system)
endif

COMPOSE_BASE     = compose.yaml
COMPOSE_OVERRIDE = compose.override.yaml
COMPOSE_PROD     = compose.prod.yaml
COMPOSE_PREFIX   = docker compose -p $(PROJECT_NAME) -f $(COMPOSE_BASE)

ifeq ($(FILE_ENV),prod)
COMPOSE = $(COMPOSE_PREFIX) -f $(COMPOSE_PROD)
else
COMPOSE = $(COMPOSE_PREFIX) -f $(COMPOSE_OVERRIDE)
endif

# -T : avoid "the input device is not a TTY" error - Example: $ make php no_tty=true
no_tty ?= false
ifeq ($(no_tty), true)
T_FLAG = -T
endif

EXEC               = $(COMPOSE) exec $(T_FLAG)
CONTAINER_PHP      = $(EXEC) php
CONTAINER_PHP_ROOT = $(EXEC) -u 0 php
PHP                = $(CONTAINER_PHP) php
COMPOSER           = $(CONTAINER_PHP) composer
CONSOLE            = $(PHP) bin/console
PHPMETRICS         = $(PHP) vendor/bin/phpmetrics
PHPCSFIXER         = $(PHP) vendor/bin/php-cs-fixer
PHPMD              = $(PHP) vendor/bin/phpmd
PHPSTAN            = $(PHP) vendor/bin/phpstan
PHPUNIT            = $(PHP) vendor/bin/phpunit

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

## — 🐳 🎵 THE SYMFONY STARTER MAKEFILE 🎵 🐳 —————————————————————————————————

# Print self-documented Makefile:
# $ make
# $ make help

.DEFAULT_GOAL = help
.PHONY: help
help: ## Print self-documented Makefile
	@grep -E '(^[.a-zA-Z_-]+[^:]+:.*##.*?$$)|(^#{2})' Makefile \ 
	| awk 'BEGIN {FS = "## "}; \
		{ \
			split($$1, line, ":"); \
			targets=line[1]; \
			description=$$2; \
			if (targets == "##") { \
				# --- space --- \
				printf "\033[33m%s\n", ""; \
			} else if (targets == "" && description != "") { \
				# --- title --- \
				printf "\033[33m\n%s\n", description; \
			} else if (targets != "" && description != "") { \
				# --- target, alias, description --- \
				split(targets, parts, " "); \
				target=parts[1]; \
				alias=parts[2]; \
				printf "\033[32m  %-26s \033[34m%-2s \033[0m%s\n", target, alias, description; \
			} \
		}'
	@echo

## — PROJECT 🚀 ———————————————————————————————————————————————————————————————

.PHONY: first
first: confirm_continue build up_d install ## The first command executed after cloning the project [y/N]

.PHONY: start
start: up_d info ## Start the project (implies detached mode)

.PHONY: stop
stop: down ## Stop the project

.PHONY: restart
restart: stop start ## Restart the project

.PHONY: install
install: confirm_continue composer_install migrate permissions git_hooks_on info ## Install (or update) the local project [y/N]

##

.PHONY: check
check: confirm_continue composer_validate phpmd phpcsfixer_check ## Check everything before you deliver [y/N]

PHONY: info
info i: ## Show info
	@$(MAKE) -s overload_file env_files vars
	@printf "\n$(Y)Info$(S)"
	@printf "\n$(Y)----$(S)\n\n"
	@printf "* Go on $(G)https://$(COMPOSE_UP_SERVER_NAME)/$(S)\n"
	@printf "* Run $(Y)make$(S) to see all shorcuts for the most common tasks.\n"
	@printf "* Run $(Y). aliases$(S) to load all the project aliases.\n"
	@printf "* Configure in your favorite IDE (see README):\n"
	@printf "  * Remote PHP interpreter (Docker)\n"
	@printf "  * PHP CS Fixer\n"
	@printf "  * PHP Mess Detector\n"
	@printf "  * PHPStan\n"
	@printf "  * PHPUnit\n"

## — SYMFONY 🎵 ———————————————————————————————————————————————————————————————

.PHONY: symfony
symfony sf: ## Run Symfony - $ make symfony [p=<params>] - Example: $ make symfony p=--help
	@$(eval p ?=)
	$(CONSOLE) $(p)

.PHONY: cc
cc: ## Clear the cache
	$(CONSOLE) cache:clear

.PHONY: cct
cct: ## Clear the cache (TEST)
	$(CONSOLE) cache:clear --env=test

.PHONY: cw
cw: ## Warm up an empty cache
	$(CONSOLE) cache:warmup --no-debug

.PHONY: about
about: ## Display information about the current project
	$(CONSOLE) about

.PHONY: dotenv
dotenv: ## Lists all dotenv files with variables and values
	$(CONSOLE) debug:dotenv

.PHONY: dumpenv
dumpenv: ## Generate .env.local.php (PROD)
	$(COMPOSER) dump-env prod

## — DOCTRINE & MYSQL 💽 ——————————————————————————————————————————————————————

.PHONY: db
db: confirm_continue ## Drop and create the database and migrate (env "dev" by default) [y/N]
	@printf "\n$(Y)Database init$(S)"
	@printf "\n$(Y)-------------$(S)\n\n"
	$(MAKE) -s db_drop no_interaction=true
	$(MAKE) -s db_create no_interaction=true
	$(MAKE) -s migrate no_interaction=true

.PHONY: db@test
db@test: confirm_continue ## Drop and create the database and migrate (env "test") [y/N]
	@printf "\n$(Y)Database init (test)$(S)"
	@printf "\n$(Y)--------------------$(S)\n\n"
	$(MAKE) -s db_drop p="--env=test" no_interaction=true
	$(MAKE) -s db_create p="--env=test" no_interaction=true
	$(MAKE) -s migrate@test no_interaction=true

.PHONY: db_drop
db_drop: confirm_continue ## Drop the database [y/N] - $ make db_drop [p=<params>] - Example: $ make db_drop p="--env=test"
	@$(eval p ?=)
	$(CONSOLE) doctrine:database:drop --if-exists --force $(p)

.PHONY: db_create
db_create: confirm_continue ## Create the database [y/N] - $ make db_create [p=<params>] - Example: $ make db_create p="--env=test"
	@$(eval p ?=)
	$(CONSOLE) doctrine:database:create --if-not-exists $(p)

##

.PHONY: validate
validate: ## Validate the mapping files - $ make validate [p=<params>] - Example: $ make validate p="--env=test"
	@$(eval p ?=)
	-$(CONSOLE) doctrine:schema:validate -v $(p)

.PHONY: update_dump_sql
update_dump_sql: ## Generate and output the SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --dump-sql

.PHONY: update_force
update_force: ## Execute the generated SQL needed to synchronize the database schema with the current mapping metadata
	$(CONSOLE) doctrine:schema:update --force

##

.PHONY: migration
migration: ## Create a new migration based on database changes
	$(CONSOLE) make:migration

.PHONY: migrate
migrate: ## Execute a migration to the latest available version - $ make migrate [p=<param>] - Example: $ make migrate p="current+3"
	@$(eval p ?=)
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing $(p)
	$(MAKE) -s --ignore-errors validate

.PHONY: migrate@test
migrate@test: ## Execute a migration to the latest available version - $ make migrate@test [p=<param>] - Example: $ make migrate@test p="current+3"
	@$(eval p ?=)
	$(CONSOLE) doctrine:migrations:migrate --no-interaction --all-or-nothing --env=test $(p)
	$(MAKE) -s validate p="--env=test"

.PHONY: list
list: ## Display a list of all available migrations and their status
	$(CONSOLE) doctrine:migrations:list

.PHONY: execute
execute: ## Execute one or more migration versions up or down manually - $ make execute p=<params> - Example: $ make execute p="DoctrineMigrations\Version20240205143239"
	@$(eval p ?=)
	$(CONSOLE) doctrine:migrations:execute $(p)

.PHONY: generate
generate: ## Generate a blank migration class
	$(CONSOLE) doctrine:migrations:generate

##

.PHONY: fixtures
fixtures: confirm_continue ## Load fixtures (CAUTION! by default the load command purges the database) [y/N] - $ make fixtures [p=<param>] - Example: $ make fixtures p="--append"
	@printf "\n$(Y)Load fixtures$(S)"
	@printf "\n$(Y)-------------$(S)\n\n"
	@$(eval p ?=)
	$(CONSOLE) doctrine:fixtures:load -n $(p)

.PHONY: fixtures@test
fixtures@test: confirm_continue ## Load fixtures (TEST) [y/N]
	@printf "\n$(Y)Load fixtures (test)$(S)"
	@printf "\n$(Y)--------------------$(S)\n\n"
	$(CONSOLE) doctrine:fixtures:load -n --env=test

##

.PHONY: sql
sql: ## Execute the given SQL query and output the results - $ make sql [q=<query>] - Example: $ make sql q="SELECT * FROM user"
	@$(eval q ?=)
	$(CONSOLE) doctrine:query:sql "$(q)"

.PHONY: sql@test
sql@test: ## Execute the given SQL query and output the results (TEST) - $ make sql@test [q=<query>] - Example: $ make sql@test q="SELECT * FROM user"
	@$(eval q ?=)
	$(CONSOLE) doctrine:query:sql "$(q)" --env=test

##

.PHONY: sql_tables
# @see https://stackoverflow.com/questions/769683/how-to-show-tables-in-postgresql
sql_tables: ## Show all tables
	$(MAKE) -s sql q="SELECT * FROM pg_catalog.pg_tables;"

.PHONY: sql_tables@test
sql_tables@test: ## Show all tables (TEST)
	$(MAKE) -s sql@test q="SELECT * FROM pg_catalog.pg_tables;"

## — COMPOSER 🧙 ——————————————————————————————————————————————————————————————

.PHONY: composer
composer: ## Run composer - $ make composer [p=<params>] - Example: $ make composer p="require --dev phpunit/phpunit"
	@$(eval p ?=)
	$(COMPOSER) $(p)

.PHONY: composer_version
composer_version: ## Composer version
	$(COMPOSER) --version

.PHONY: composer_validate
composer_validate: ## Validate composer.json and composer.lock
	@printf "\n$(Y)Composer validate$(S)"
	@printf "\n$(Y)-----------------$(S)\n\n"
	$(COMPOSER) validate --strict --check-lock

##

.PHONY: composer_install
composer_install: ## Install packages using composer
	$(COMPOSER) install

.PHONY: composer_install@prod
composer_install@prod: ## Install packages using composer (PROD)
	$(COMPOSER) install --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

.PHONY: composer_update
composer_update: ## Update packages using composer
	$(COMPOSER) update

.PHONY: composer_update@prod
composer_update@prod: ## Update packages using composer (PROD)
	$(COMPOSER) update --verbose --prefer-dist --no-progress --no-interaction --no-dev --optimize-autoloader

##

.PHONY: composer_clean
composer_clean: ## Remove vendor/
	rm -rf vendor

## — PHP 🐘 ———————————————————————————————————————————————————————————————————

.PHONY: php
php: ## Run PHP - $ make php [p=<params>]- Example: $ make php p=--version
	@$(eval p ?=)
	$(PHP) $(p)

.PHONY: php_sh
php_sh: ## Connect to the PHP container
	$(CONTAINER_PHP) sh

.PHONY: php_version
php_version: ## PHP version number
	$(PHP) -v

.PHONY: php_modules
php_modules: ## Show compiled in modules
	$(PHP) -m

## — DOCKER 🐳 ————————————————————————————————————————————————————————————————

.PHONY: compose
compose: ## Execute compose with default options - $ make compose [p=<params>] - Example: $ make compose p=--help
	@$(eval p ?=)
	$(COMPOSE) $(p)

.PHONY: up
up: ## Start the container - $ make up [p=<params>] - Example: $ make up p=-d
	@$(eval p ?=)
	$(COMPOSE_UP_ENV_BASE) $(COMPOSE_UP_ENV_VARS) $(COMPOSE) up --remove-orphans --pull always $(p)

.PHONY: up_d
up_d: ## Start the container (wait for services to be running|healthy - detached mode)
	$(MAKE) up p="--wait -d"

.PHONY: down
down: ## Stop the container
	$(COMPOSE) down --remove-orphans

.PHONY: build
build: ## Build or rebuild services - $ make build [p=<params>] - Example: $ make build p=--no-cache
	@$(eval p ?=)
	$(COMPOSE) build $(COMPOSE_BUILD_OPTS) $(p)

.PHONY: logs
logs: ## View output from containers
	$(COMPOSE) logs

.PHONY: config
config: ## Parse, resolve and render compose file in canonical format
	$(COMPOSE) config

##

.PHONY: docker_stop_all
docker_stop_all: confirm_continue ## Stop all running containers [y/N]
	docker stop $$(docker ps -a -q)

.PHONY: docker_remove_all
docker_remove_all: confirm_continue ## Remove all stopped containers [y/N]
	docker rm $$(docker ps -a -q)

## — TESTS / QUALITY ✅ ———————————————————————————————————————————————————————

.PHONY: tests
tests: confirm_continue unit ## Run all tests [y/N]

.PHONY: phpunit
phpunit: ## Run PHPUnit - $ make phpunit [p=<params>] - Example: $ make phpunit p="tests/myTest.php"
	@$(eval p ?=)
	$(PHPUNIT) $(p)

##

.PHONY: unit
unit: confirm_continue ## Run unit tests [y/N]
	@printf "\n$(Y)Unit tests$(S)"
	@printf "\n$(Y)----------$(S)\n\n"
	$(PHPUNIT) --testsuite unit

PHONY: unit_coverage
unit_coverage: confirm_continue ## Generate code coverage report in HTML format for unit tests [y/N]
	@printf "\n$(Y)Unit tests (coverage)$(S)"
	@printf "\n$(Y)---------------------$(S)\n\n"
	@printf "Generate code coverage report in HTML format for unit tests in the $(Y)$(COVERAGE_DIR)$(S) directory.\n"
	$(PHPUNIT) --testsuite unit --coverage-html $(COVERAGE_DIR)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(COVERAGE_INDEX)$(S)\n"

.PHONY: unit_dox
unit_dox: confirm_continue ## Report test execution progress in TestDox format for unit tests [y/N]
	@printf "\n$(Y)Unit tests (testdox)$(S)"
	@printf "\n$(Y)--------------------$(S)\n\n"
	$(PHPUNIT) --testsuite unit --testdox

##

.PHONY: application
application: confirm_continue ## Run application tests (functional) [y/N]
	@printf "\n$(Y)Application tests$(S)"
	@printf "\n$(Y)-----------------$(S)\n\n"
	$(PHPUNIT) --testsuite application

PHONY: application_coverage
application_coverage: confirm_continue application_setup ## Generate code coverage report in HTML format for application tests [y/N]
	@printf "\n$(Y)Application tests (coverage)$(S)"
	@printf "\n$(Y)----------------------------$(S)\n\n"
	@printf "Generate code coverage report in HTML format for application tests in the $(Y)$(COVERAGE_DIR)$(S) directory.\n"
	$(PHPUNIT) --testsuite application --coverage-html $(COVERAGE_DIR)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(COVERAGE_INDEX)$(S)\n"

PHONY: application_setup
application_setup: confirm_continue db@test fixtures@test ## Setup before launch application tests [y/N]

##

.PHONY: xdebug_version
xdebug_version: ## Xdebug version number
	$(PHP) -r "var_dump(phpversion('xdebug'));"

##

.PHONY: phpmetrics
phpmetrics: ## Run PhpMetrics - $ make phpmetrics [p=<params>] - Example: $ make phpmetrics p=--help
	@$(eval p ?=)
	$(PHPMETRICS) $(p)

.PHONY: phpmetrics_report
phpmetrics_report: confirm_continue ## Generate the PhpMetrics HTML report
	@printf "\n$(Y)PhpMetrics HTML report$(S)"
	@printf "\n$(Y)----------------------$(S)\n\n"
	@printf "Parse $(G)$(PHPMETRICS_DIR)$(S) and generate the PhpMetrics HTML report in the $(Y)$(PHPMETRICS_REPORT)$(S) directory.\n"
	$(PHPMETRICS) --report-html="$(PHPMETRICS_REPORT)" $(PHPMETRICS_DIR)
	@printf " $(G)✔$(S) Open in your favorite browser the file $(Y)$(PHPMETRICS_INDEX)$(S)\n"

##

.PHONY: phpmd
phpmd: ## Run PHP Mess Detector - $ make phpmd [p=<params>] - Example: $ make phpmd p=src/Kernel.php
	@printf "\n$(Y)PHP Mess Detector$(S)"
	@printf "\n$(Y)-----------------$(S)\n\n"
	@$(eval p ?= $(PHPMD_DIR))
	$(PHPMD) $(p) ansi phpmd.xml

.PHONY: phpstan
phpstan: ## Run PHPStan - $ make phpstan [p=<params>] - Example: $ make phpstan p="src tests"
	@$(eval p ?=)
	$(PHPSTAN) $(p)

.PHONY: phpstan_analyse
phpstan_analyse: ## Run PHPStan analyse - $ make phpstan_analyse [p=<params>] - Example: $ make phpstan_analyse p="src tests"
	@printf "\n$(Y)PHPStan analyse$(S)"
	@printf "\n$(Y)---------------$(S)\n\n"
	@$(eval p ?=)
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(p)

.PHONY: phpstan_baseline
phpstan_baseline: ## Generate PHPStan baseline - $ make phpstan_baseline [p=<params>] - Example: $ make phpstan_baseline p="src tests"
	@printf "\n$(Y)PHPStan baseline$(S)"
	@printf "\n$(Y)----------------$(S)\n\n"
	@$(eval p ?=)
	$(PHPSTAN) analyse -c $(PHPSTAN_CONFIG) $(p) --generate-baseline $(PHPSTAN_BASELINE)

##

.PHONY: phpcsfixer
phpcsfixer: ## Run PHP CS Fixer version - $ make phpcsfixer [p=<params>] - Example: $ make phpcsfixer p=list
	@$(eval p ?=)
	$(PHPCSFIXER) $(p)

.PHONY: phpcsfixer_check
phpcsfixer_check: ## Check code style
	@printf "\n$(Y)PHP CS Fixer$(S)"
	@printf "\n$(Y)------------$(S)\n\n"
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) check -v

.PHONY: phpcsfixer_fix
phpcsfixer_fix: ## Fix code style
	$(PHPCSFIXER) --config=$(PHPCSFIXER_CONFIG) fix

.PHONY: phpcsfixer_version
phpcsfixer_version: ## Show PHP CS Fixer version
	$(PHPCSFIXER) --version

## — GIT 🐙 ———————————————————————————————————————————————————————————————————

.PHONY: git_hooks_on
git_hooks_on on: ## Use the hooks directory of this project
	git config core.hooksPath hooks/

.PHONY: git_hooks_off
git_hooks_off of: ## Use the default hooks directory of Git
	git config --unset core.hooksPath

.PHONY: git_hooks_pre_push
git_hooks_pre_push: check ## Actions on pre-push

## — TROUBLESHOOTING 😵‍️ ———————————————————————————————————————————————————————

.PHONY: permissions
permissions p: ## Run it if you cannot edit some of the project files on Linux (https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md)
	@printf "\n$(Y)Permissions$(S)"
	@printf "\n$(Y)-----------$(S)\n\n"
	$(COMPOSE) run --rm php chown -R $(USER_ID):$(GROUP_ID) .
	@printf " $(G)✔$(S) You are now defined as the owner $(Y)$(USER_ID):$(GROUP_ID)$(S) of the project files.\n"

## — UTILS 🛠️  —————————————————————————————————————————————————————————————————

.PHONY: overload_file
overload_file: ## Show overload file loaded into that Makefile
	@printf "\n$(Y)Overload file$(S)"
	@printf "\n$(Y)-------------$(S)\n\n"
	@printf "File loaded into that Makefile:\n\n"
ifneq ("$(wildcard overload/.env)","")
	@printf "* $(G)✔$(S) overload/.env\n"
else
	@printf "* $(R)⨯$(S) overload/.env\n"
endif

.PHONY: env_files
env_files: ## Show Symfony env files loaded into that Makefile
	@printf "\n$(Y)Symfony env files$(S)"
	@printf "\n$(Y)-----------------$(S)\n\n"
	@printf "Files loaded into that Makefile (in order of decreasing priority) $(Y)[FILE_ENV=$(FILE_ENV)]$(S):\n\n"
ifneq ("$(wildcard .env.$(FILE_ENV).local)","")
	@printf "* $(G)✔$(S) .env.$(FILE_ENV).local\n"
else
	@printf "* $(R)⨯$(S) .env.$(FILE_ENV).local\n"
endif
ifneq ("$(wildcard .env.$(FILE_ENV))","")
	@printf "* $(G)✔$(S) .env.$(FILE_ENV)\n"
else
	@printf "* $(R)⨯$(S) .env.$(FILE_ENV)\n"
endif
ifneq ("$(wildcard .env.local)","")
	@printf "* $(G)✔$(S) .env.local\n"
else
	@printf "* $(R)⨯$(S) .env.local\n"
endif
ifneq ("$(wildcard .env)","")
	@printf "* $(G)✔$(S) .env\n"
else
	@printf "* $(R)⨯$(S) .env\n"
endif

.PHONY: vars
vars: ## Show variables
	@printf "\n$(Y)Vars$(S)"
	@printf "\n$(Y)----$(S)\n"
	@printf "\n$(G)USER$(S)\n"
	@printf "  USER_ID : $(USER_ID)\n"
	@printf "  GROUP_ID: $(GROUP_ID)\n"
	@printf "\n$(G)OVERLOADING$(S)\n"
	@printf "  PROJECT_NAME          : $(PROJECT_NAME)\n"
	@printf "  COMPOSE_BUILD_OPTS    : $(COMPOSE_BUILD_OPTS)\n"
	@printf "  COMPOSE_UP_SERVER_NAME: $(COMPOSE_UP_SERVER_NAME)\n"
	@printf "  COMPOSE_UP_ENV_BASE   : $(COMPOSE_UP_ENV_BASE)\n"
	@printf "  COMPOSE_UP_ENV_VARS   : $(COMPOSE_UP_ENV_VARS)\n"
	@printf "\n$(G)SYMFONY ENVIRONMENT VARIABLES$(S)\n"
	@printf "  APP_ENV   : $(APP_ENV)\n"
	@printf "  APP_SECRET: $(APP_SECRET)\n"
	@printf "\n$(G)DOCKER$(S)\n"
	@printf "  COMPOSE_V2: $(COMPOSE_V2)\n"
	@printf "  COMPOSE   : $(COMPOSE)\n"

## — INTERNAL 🚧‍️ ——————————————————————————————————————————————————————————————

.PHONY: confirm
confirm: ## Display a confirmation before executing a makefile command - @$(MAKE) -s confirm question=<question> [make_yes=<command>] [make_no=<command>] [no_interaction=<bool>]
	@$(if $(question),, $(error question argument is required))   # Question to display
	@$(eval make_yes ?=)                                          # Makefile commands to execute on yes
	@$(eval make_no ?=)                                           # Makefile commands to execute on no
	@$(eval no_interaction ?=)                                    # Interactive question or not
	@\
	question=$${question:-"Confirm?"}; \
	if [ "$${no_interaction}" != "true" ]; then \
		printf "$(G)$${question}$(S) [$(Y)y/N$(S)]: " && read answer; \
	fi; \
	answer=$${answer:-N}; \
	if [ "$${answer}" = y ] || [ "$${answer}" = Y ] || [ "$${no_interaction}" = "true" ]; then \
		[ -z "$$make_yes" ] && printf "$(Y)(YES) no action!$(S)\n" || $(MAKE) -s $$make_yes no_interaction=true; \
	else \
		[ -z "$$make_no" ] && printf "$(Y)(NO) no action!$(S)\n" || $(MAKE) -s $$make_no; \
	fi

PHONY: confirm_continue
confirm_continue: ## Display a confirmation before continuing [y/N]
	@$(eval no_interaction ?=) # Interactive question or not
	@if [ "$${no_interaction}" = "true" ]; then exit 0; fi; \
	printf "$(G)Do you want to continue?$(S) [$(Y)y/N$(S)]: " && read answer && [ $${answer:-N} = y ]
