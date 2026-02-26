#!/bin/bash

# docker compose up

# Je veux que ce fonction dans tous les run donc je unmigrate et remigrate pour cela mais vous pouvez ingnorez et tester vous même

docker compose exec backend npx sequelize-cli db:migrate:undo:all
docker compose exec backend npx sequelize-cli db:migrate

docker compose exec backend npx sequelize-cli db:seed:undo:all
docker compose exec backend npx sequelize-cli db:seed:all
