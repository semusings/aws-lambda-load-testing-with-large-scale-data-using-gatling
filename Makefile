.PHONY: help
.DEFAULT_GOAL := help

help:
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@echo "				AWS Lambda load testing with large scale data using Gatling"
	@echo ""
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

test: ## Test the project
	load-testing/runLoadtestRemotely.sh

##@ Releasing

version: ## Get the current build version
	@src/cicd/before_install.sh

deploy: ## Publish the project
	serverless deploy --stage test --region us-east-1