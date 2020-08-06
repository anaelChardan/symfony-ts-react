.DEFAULT_GOAL := help

CURRENT_DIR := $(shell pwd)
DOCKER_COMPOSE=docker-compose
PHP_EXEC=$(DOCKER_COMPOSE) exec -u www-data fpm php
PHP_RUN=$(DOCKER_COMPOSE) run --rm -u www-data php php
YARN_RUN=$(DOCKER_COMPOSE) run --rm node yarn
CURRENT_USER_ID=$(shell id -u)
CURRENT_GROUP_ID=$(shell id -g)

.PHONY: help
help:
	@echo ""
	@echo "Symfony Typescript available targets: "
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

####################################################### Docker     #####################################################

.PHONY: start
start: ## Start the project
	$(DOCKER_COMPOSE) up -d --remove-orphan ${C}

.PHONY: stop
stop: ## Stop the projet
	$(DOCKER_COMPOSE) stop

.PHONY: down
down: ## Down the project
	$(DOCKER_COMPOSE) down -v

.PHONY: php-image-dev
php-image-dev: ## Build the dev docker image
	DOCKER_BUILDKIT=1 docker build --build-arg USER_ID=$(CURRENT_USER_ID) --build-arg USER_GROUP=$(CURRENT_GROUP_ID) --progress=plain --pull --tag symfonytypescript/dev/php:7.4 --target dev ./infrastructure

.PHONY: php-image-dev-mac
php-image-dev-mac: ## Build the dev docker image
	DOCKER_BUILDKIT=1 docker build --pull --tag symfonytypescript/dev/php:7.4 --target dev ./infrastructure

.PHONY: debug
debug: ## Enable Xdebug
	XDEBUG_ENABLED=1 $(DOCKER_COMPOSE) up -d --remove-orphan ${C}

.PHONY: stopdebug
stopdebug: ## Disable Xdebug
	XDEBUG_ENABLED=0 $(DOCKER_COMPOSE) up -d --remove-orphan ${C}

.PHONY: enter
enter: ## Enter in the php container
	$(PHP_RUN) /bin/bash

################################################# Install ##############################################################
application/composer.lock: application/composer.json
	$(PHP_RUN) /usr/local/bin/composer update

application/vendor: application/composer.lock
	$(PHP_RUN) /usr/local/bin/composer install

application/node_modules: application/package.json
	$(YARN_RUN) install

.PHONY: composer
composer: ## Run make composer F="<your-composer-args>"
	$(PHP_RUN) /usr/local/bin/composer ${F}

.PHONY: yarn
yarn: ## Run make yarn F="<your-yarn-args>"
	$(YARN_RUN) ${F}
	$(MAKE) front-restart

.PHONY: front-watch
front-watch: ## Run make yarn F="<your-yarn-args>"
	$(YARN_RUN) encore dev --watch

.PHONY: front-watch-mac
front-watch-mac: ## Build front assets --watch for mac
	@cd application && yarn encore dev --watch

.PHONY: cache
cache: application/vendor ## Remove the cache
	rm -rf var/cache && $(PHP_RUN) bin/console cache:warmup

.PHONY: sf
sf: ## Call the symfony console in dev mode (make sf F="cache:clear" by example)
	APP_ENV=dev $(PHP_RUN) bin/console ${F}

.PHONY: sf-prod
sf-prod: ## Call the symfony console in prod mode (make sf-prod F="cache:clear" by example)
	APP_ENV=prod $(PHP_RUN) bin/console ${F}

.PHONY: app-dev
app-dev: application/vendor application/node_modules ## install application in dev mode
	APP_ENV=dev $(MAKE) start
	./infrastructure/wait_docker.sh
	APP_ENV=dev $(MAKE) cache

.PHONY: front-restart
front-restart: ## Restart your node container
	APP_ENV=dev docker-compose restart node

.PHONY: front-logs
front-logs: ## Display front logs (useful for watch)
	docker-compose logs -f node

.PHONY: install
install: application/vendor application/node_modules ## install Front + Back dependencies

