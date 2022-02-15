#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
VERSION=${VERSION}
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf ./sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}//repository/sausage-store-rybalka-dmitrii-backend/com/yandex/practicum/devops/sausage-store/'${VERSION}'/sausage-store-'${VERSION}'.jar
sudo cp ./sausage-store-$VERSION.jar /home/jarservice/sausage-store.jar || true #"jar||true" говорит, если команда обвалится — продолжай
sudo mkdir /etc/systemd/system/sausage-store-backend.service.d || true

sudo cat <<EOF>  /etc/systemd/system/sausage-store-backend.service.d/override.conf
Environment="PSQL_HOST=${PSQL_HOST}"
Environment="PSQL_PORT=6432"
Environment="PSQL_DBNAME=${PSQL_DBNAME}"
Environment="PSQL_USER=${PSQL_USER}"
Environment="PSQL_PASSWORD=${PSQL_PASSWORD}"
Environment="MONGO_USER=${MONGO_USER}"
Environment="MONGO_PASSWORD=${MONGO_PASSWORD}"
Environment="MONGO_URL=${MONGO_URL}"
Environment="MONGO_DATABASE=${MONGO_DATABASE}"
EOF

sudo chown -R student:student /home/student/sausage-store.jar
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend
