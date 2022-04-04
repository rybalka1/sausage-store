#!/bin/bash
set +e
cat >.env <<EOF
SPRING_DATASOURCE_URL=${PSQL_DATASOURCE}
SPRING_DATASOURCE_USERNAME=${PSQL_USER}
SPRING_DATASOURCE_PASSWORD=${PSQL_PASSWORD}
SPRING_DATA_MONGODB_URI=${MONGO_DATA}
VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN}
SPRING_CLOUD_VAULT_TOKEN=${VAULT_TOKEN}
SPRING_CLOUD_VAULT_HOST=${VAULT_HOST}
REPORT_PATH=${REPORT_PATH}
LOG_PATH=${REPORT_PATH}
EOF

docker network create -d bridge sausage_network || true
docker login gitlab.praktikum-services.ru:5050 -u $DOCKER_GITLAB_USER_NAME -p $DOCKER_GITLAB_TOCKEN
docker pull gitlab.praktikum-services.ru:5050/rybalka-dmitrii/sausage-store/sausage-backend-report:latest

docker stop sausage-backend_report || true
docker rm sausage-backend-report -f || true
set -e
docker run -d --name sausage-backend-report \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    gitlab.praktikum-services.ru:5050/rybalka-dmitrii/sausage-store/sausage-backend-report:latest
