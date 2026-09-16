COMPOSE := docker compose --env-file infra/docker/.env -f infra/docker/compose.yaml

.PHONY: env up down logs ps reset

env:
	test -f infra/docker/.env || cp infra/docker/.env.example infra/docker/.env

up: env
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

reset:
	$(COMPOSE) down -v
	$(MAKE) up
