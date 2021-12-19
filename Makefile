include .env
export

.DEFAULT_GOAL := help
.PHONY: help

help:
	@echo 'Current APP_NAME: '`echo ${APP_NAME}`

build-all: build-nginx build-php-fpm build-php-cli build-mysql

build-nginx:
	@docker build \
		--pull \
		-t ${APP_NAME}-nginx:${NGINX_VERSION} \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
		-f ./images/nginx.Dockerfile \
		.

build-php-fpm:
	@docker build \
		--pull \
		-t ${APP_NAME}-php-fpm:${PHP_VERSION} \
		--build-arg PHP_VERSION=${PHP_VERSION} \
		--build-arg XDEBUG_VERSION=${XDEBUG_VERSION} \
		-f ./images/php-fpm.Dockerfile \
		.

build-php-cli: ## Build PHP-CLI image (APP_NAME-php-cli:latest)
	@docker build \
		--pull \
		-t ${APP_NAME}-php-cli:${PHP_VERSION} \
		--build-arg PHP_VERSION=${PHP_VERSION} \
		--build-arg XDEBUG_VERSION=${XDEBUG_VERSION} \
		-f ./images/php-cli.Dockerfile .

build-mysql: ## Build PHP-CLI image (APP_NAME-php-cli:latest)
	@docker build \
		--pull \
		-t ${APP_NAME}-mysql:${MYSQL_VERSION} \
		--build-arg MYSQL_VERSION=${MYSQL_VERSION} \
		-f ./images/mysql.Dockerfile .

up:
	@docker-compose up -d

ps:
	@docker-compose ps

down:
	@docker-compose down \
		--volumes \
		--remove-orphans

remove-images:
	@docker-compose down \
		--rmi all
		--remove-orphans
