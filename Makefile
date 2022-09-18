# Setup ————————————————————————————————————————————————————————————————————————

# Parameters
PROJECT       = my-app
HTTP_PORT     = 8081
REDIS_PORT    = 6389

# Executables
EXEC_PHP      = php
COMPOSER      = composer
GIT           = git
REDIS         = redis-cli
YARN          = yarn

# Alias
ARTISAN       = $(EXEC_PHP) artisan # or: docker-compose exec my_php_container $(EXEC_PHP) bin/artisan
SYMFONY       = $(EXEC_PHP) bin/console # or: docker-compose exec my_php_container $(EXEC_PHP) bin/console

# Executables: vendors
PHP_CS        = ./vendor/bin/phpcs
PHP_CS_BF     = ./vendor/bin/phpcbf
PHPMD         = ./vendor/bin/phpmd
PHPSTAN       = ./vendor/bin/phpstan
PHPUNIT       = ./vendor/bin/phpunit
PSALM         = ./vendor/bin/psalm

# Executables: local only
LARAVEL_BIN   = laravel
SYMFONY_BIN   = symfony
DOCKER        = docker
DOCKER_COMP   = 'docker compose'

.DEFAULT_GOAL := help

#--------------------------------------
# General
#--------------------------------------
.PHONY: help
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

#--------------------------------------
# Composer
#--------------------------------------
.PHONY: install
install: composer.lock ## Install vendors according to the current composer.lock file
	@$(COMPOSER) install --no-progress --prefer-dist --optimize-autoloader

#--------------------------------------
# Symfony 🎵
#--------------------------------------
.PHONY: sf
sf: ## List all Symfony commands
	@$(SYMFONY)

.PHONY: sf-cc
sf-cc: ## Clear the cache. DID YOU CLEAR YOUR CACHE????
	@$(SYMFONY) cache:clear

.PHONY: sf-warmup
sf-warmup: ## Warmup the cache
	@$(SYMFONY) cache:warmup

.PHONY: sf-migrate
sf-migrate: ## Migrate database changes
	@$(SYMFONY) doctrine:migrate:migrate

.PHONY: sf-fix-perms
sf-fix-perms: ## Fix permissions of all var files
	@chmod -R 777 var/*

.PHONY: sf-assets
sf-assets: purge ## Install the assets with symlinks in the public folder
	@$(SYMFONY) assets:install public/ # Don't use "--symlink --relative" with a Docker env

.PHONY: sf-purge
sf-purge: ## Purge cache and logs
	@rm -rf var/cache/* var/log/*

.PHONY: sf-commands
sf-commands: ## Display all commands in the project namespace
	@$(SYMFONY) list $(PROJECT)

.PHONY: sf-load-fixtures
sf-load-fixtures: ## Build the DB, control the schema validity, load fixtures and check the migration status
	@$(SYMFONY) doctrine:cache:clear-metadata
	@$(SYMFONY) doctrine:database:create --if-not-exists
	@$(SYMFONY) doctrine:schema:drop --force
	@$(SYMFONY) doctrine:schema:create
	@$(SYMFONY) doctrine:schema:validate
	@$(SYMFONY) doctrine:fixtures:load --no-interaction

#--------------------------------------
# Laravel 🎵
#--------------------------------------
.PHONY: art
art: ## List all Laravel commands
	@$(LARAVEL)

.PHONY: art-cc
art-cc: ## Clear the cache. DID YOU CLEAR YOUR CACHE????
	@$(LARAVEL) cache:clear

.PHONY: art-migrate
art-migrate: ## Migrate database changes
	@$(LARAVEL) migrate

.PHONY: art-commands
art-commands: ## Display all commands in the project namespace
	@$(LARAVEL) list $(PROJECT)

.PHONY: art-load-fixtures
art-load-fixtures: ## Load fixtures
	@$(LARAVEL) migrate --seed

#--------------------------------------
# Docker 🐳
#--------------------------------------
.PHONY: up
up: ## Start the docker hub
	$(DOCKER_COMP) up --detach

.PHONY: build
build: ## Builds the images
	$(DOCKER_COMP) build --pull --no-cache

.PHONY: down
down: ## Stop the docker hub
	$(DOCKER_COMP) down --remove-orphans

.PHONY: sh
sh: ## Log to the docker container
	@$(DOCKER_COMP) exec php sh

.PHONY: logs
logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

.PHONY: wait-for-database
wait-for-database: ## Wait for database to be ready
	@bin/wait-for-database.sh

.PHONY: wait-for-opensearch
wait-for-opensearch: ## Wait for opensearch to be ready
	@bin/wait-for-opensearch.sh

.PHONY: bash
bash: ## Connect to the application container
	@$(DOCKER) container exec -it php bash

#--------------------------------------
# Project 🐝
#--------------------------------------
.PHONY: start
start: up wait-for-database load-fixtures wait-for-opensearch populate serve ## Start docker, load fixtures, populate the OpenSearch index and start the webserver

.PHONY: reset
reset: load-fixtures ## Load fixtures

.PHONY: stop
stop: down unserve ## Stop docker and the Symfony binary server

.PHONY: cc-redis
cc-redis: ## Flush all Redis cache
	@$(REDIS) -p $(REDIS_PORT) flushall

#--------------------------------------
# Tests ✅
#--------------------------------------
.PHONY: tests
tests: test-phpunit phpstan ## Run all tests

.PHONY: phpunit
phpunit: phpunit.xml check ## Run phpunit
	@$(PHPUNIT) --stop-on-failure

#--------------------------------------
# Coding standards ✨
#--------------------------------------
.PHONY: fix-cs
fix-cs: phpcsbf ## Run fixing the sourcecode automatically

.PHONY: cs
cs: phpcs phpmd lint-php lint-js ## Run all coding standards checks

.PHONY: static-analysis
static-analysis: phpstan psalm ## Run the static analysis

.PHONY: phpcs
phpcs: ## Run phpcs
	@$(PHP_CS)

.PHONY: phpcsbf
phpcsbf: ## Run phpcs bf
	@$(PHP_CS_BF)

.PHONY: phpmd
phpmd: ## Run phpmd
	@$(PHPMD) src,tests ansi cleancode

.PHONY: phpstan
phpstan: ## Run phpstan
	@$(PHPSTAN) analyse -l 9 -c phpstan.neon --memory-limit 1G

.PHONY: psalm
psalm: ## Run psalm
	@$(PSALM)

#--------------------------------------
# Yarn 🐱 / JavaScript
#--------------------------------------
.PHONY: dev
dev: ## Rebuild assets for the dev env
	@$(YARN) install --check-files
	@$(YARN) run encore dev

.PHONY: watch
watch: ## Watch files and build assets when needed for the dev env
	@$(YARN) run encore dev --watch

.PHONY: encore
encore: ## Build assets for production
	@$(YARN) run encore production

.PHONY: lint-js
lint-js: ## Lints JS coding standards
	@$(YARN) run eslint assets/js

.PHONY: fix-js
fix-js: ## Fixes JS files
	@$(YARN) run eslint assets/js --fix

#--------------------------------------
# Code Quality reports 📊
#--------------------------------------
#.PHONY: report-metrics
#report-metrics:
#tbd

#--------------------------------------
# Deploy & Prod 🚀
#--------------------------------------
#.PHONY: deploy
#deploy:
# tbd
