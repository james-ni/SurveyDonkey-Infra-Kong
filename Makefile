APP_NAME = SurveyDonkey
APP_VERSION ?= v1
SERVICE_NAME = infra
APP_ENVIRONMENT ?= dev


#Export Variables into child processes
.EXPORT_ALL_VARIABLES:


deploy_flyway_layer:
	bash cicd/scripts/deploy_flyway_layer.sh
.PHONY: deploy_flyway_layer

clean:
	docker-compose down --remove-orphans
	bash cicd/scripts/clean.sh
.PHONY: clean
