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
docker pull gitlab.praktikum-services.ru:5050/rybalka-dmitrii/sausage-store/sausage-frontend:$VERSION

docker stop sausage-frontend || true
docker rm sausage-frontend || true
set -e
docker run -d --name sausage-frontend \
    --network=sausage_network \
    --restart always \
    --env-file .env \
    -p 8082:80 \
    gitlab.praktikum-services.ru:5050/rybalka-dmitrii/sausage-store/sausage-frontend:$VERSION
