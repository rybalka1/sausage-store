#!/bin/bash
set +e
cat >.env <<EOF
VAULT_HOST=${VAULT_HOST}
VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN}
SPRING_CLOUD_VAULT_TOKEN=${VAULT_TOKEN}
SPRING_CLOUD_VAULT_HOST=${VAULT_HOST}
REPORT_PATH=${REPORT_PATH}
LOG_PATH=${REPORT_PATH}

VERSION=${VERSION}
BACKEND_IMAGE_URL=${BACKEND_IMAGE_URL}
BACKEND_REPORT_IMAGE_URL=${BACKEND_REPORT_IMAGE_URL}
FRONTEND_IMAGE_URL=${FRONTEND_IMAGE_URL}
VIRTUAL_HOST=${VIRTUAL_HOST}
VIRTUAL_PORT=${VIRTUAL_PORT}
DEFAULT_HOST=${DEFAULT_HOST}
EOF
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD $DOCKER_CI
set -e

ls -alht
echo VAULT_HOST=${VAULT_HOST}
echo VAULT_DEV_ROOT_TOKEN_ID=${VAULT_TOKEN}
echo SPRING_CLOUD_VAULT_TOKEN=${VAULT_TOKEN}
echo SPRING_CLOUD_VAULT_HOST=${VAULT_HOST}
echo REPORT_PATH=${REPORT_PATH}
echo LOG_PATH=${REPORT_PATH}
echo VERSION=${VERSION}
echo BACKEND_IMAGE_URL=${BACKEND_IMAGE_URL}
echo BACKEND_REPORT_IMAGE_URL=${BACKEND_REPORT_IMAGE_URL}
echo FRONTEND_IMAGE_URL=${FRONTEND_IMAGE_URL}
echo VIRTUAL_HOST=${VIRTUAL_HOST}
echo VIRTUAL_PORT=${VIRTUAL_PORT}
echo DEFAULT_HOST=${DEFAULT_HOST}

# Создаем все службы из файл docker-compose.yml без автоматического запуска
# Это нужно если мы деплоим приложение в первый раз и они еще не созданы либо предварительно остановлены через docker-compose down
docker-compose up --no-start frontend sausage-backend-blue sausage-backend-green report

# Проверяем какой backend в данный момент запущен
# Если запущен $CUR мы будем обновлять $OLD
if [ "$(docker ps --filter name=sausage-backend-blue --quiet)" ]; then
    CUR="sausage-backend-blue"
    OLD="sausage-backend-green"
else
    CUR="sausage-backend-green"
    OLD="sausage-backend-blue"
fi

# Если мы деплоим приложение в первый раз запускаем службы frontend и report
# При этом если службы запущены повторный запуск не произойдет и не приведет к даунтайму
docker-compose start frontend report

# Если backend, который собираемся обновить, запущен, останавливаем его
if [ "$(docker container inspect -f '{{.State.Running}}' $OLD)" == "true" ]; then docker-compose stop $OLD; fi

# Скачиваем новую версию docker image для backend
docker pull $BACKEND_IMAGE_URL

# Запускаем обновленную версию backend
docker-compose start $OLD
set +e

# Ждем пока статус обновленого backend не сменится на healthy. Пауза между выполнениями 3 секунды, 60 попыток. Итого 3 минуты, если статус не сменился на healthy выходим с кодом 1.
max_retry=60
counter=0
until [ "$(docker inspect -f {{.State.Health.Status}} $OLD)" == "healthy" ]; do
    sleep 3
    [[ counter -eq $max_retry ]] && echo "fail!" && exit 1
    echo "Пробуем снова, попытка #$counter"
    ((counter++))
done

set -e
# Останавливаем текущий backend
docker-compose stop $CUR
echo "Обновлен $OLD"
