#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
# VERSION=${VERSION}
PSQL_HOST=${PSQL_HOST}
PSQL_DBNAME=${PSQL_DBNAME}
PSQL_USER=${PSQL_USER}
PSQL_PASSWORD=${PSQL_PASSWORD}
MONGO_USER=${MONGO_USER}
MONGO_PASSWORD=${MONGO_PASSWORD}
MONGO_HOSTNAME=${MONGO_HOSTNAME}
MONGO_DATABASE=${MONGO_DATABASE}
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp ./sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}/repository/sausage-store-rybalka-dmitrii-backend/com/yandex/practicum/devops/sausage-store/${VERSION}/sausage-store-${VERSION}.jar
# sudo cp ./sausage-store-${VERSION}.jar ./sausage-store.jar || true #"jar||true" говорит, если команда обвалится — продолжай
# touch ~/sausage-unit-variables.conf.temp || true
cat <<EOF > ~/sausage-unit-variables.conf.temp
[Service]
Environment="PSQL_HOST='$PSQL_HOST'"'
Environment="PSQL_PORT=6432"
Environment="PSQL_DBNAME='$PSQL_DBNAME'"
Environment="PSQL_USER='$PSQL_USER'"
Environment="PSQL_PASSWORD='$PSQL_PASSWORD'"
Environment="MONGO_USER='$MONGO_USER'"
Environment="MONGO_PASSWORD='$MONGO_PASSWORD'"
Environment="MONGO_HOSTNAME='$MONGO_HOSTNAME'"
Environment="MONGO_DATABASE='$MONGO_DATABASE'"
EOF
sudo -s
mkdir /etc/systemd/system/sausage-store-backend.service.d || true
cp /home/student/sausage-unit-variables.conf.temp /etc/systemd/system/sausage-store-backend.service.d/sausage-unit-variables.conf
sudo chmod 600 /etc/systemd/system/sausage-store-backend.service.d/sausage-unit-variables.conf
exit

sudo chown -R student:student /home/student/sausage-store.jar
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend
