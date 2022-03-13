#!/bin/bash
set +e
cat >.env <<EOF
REPORT_PATH=/tmp
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
EOF
docker network create -d bridge sausage_network || true
docker login gitlab.praktikum-services.ru:5050 -u $DOCKER_GITLAB_USER_NAME -p $DOCKER_GITLAB_TOCKEN
docker pull gitlab.praktikum-services.ru:5050/rybalka-dmitrii/sausage-store/sausage-backend:$VERSION

docker stop sausage-backend || true
docker rm sausage-backend || true
set -e
docker run -d --name sausage-backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    gitlab.praktikum-services.ru:5050/rybalka-dmitrii/sausage-store/sausage-backend:$VERSION

