#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
VERSION=${VERSION}
PSQL_HOST=${PSQL_HOST}
PSQL_DBNAME=${PSQL_DBNAME}
PSQL_USER=${PSQL_USER}
PSQL_PASSWORD=${PSQL_PASSWORD}
MONGO_USER=${MONGO_USER}
MONGO_PASSWORD=${MONGO_PASSWORD}
MONGO_URL=${MONGO_URL}
MONGO_DATABASE=${MONGO_DATABASE}

#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf ./sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}//repository/sausage-store-rybalka-dmitrii-backend/com/yandex/practicum/devops/sausage-store/'${VERSION}'/sausage-store-'${VERSION}'.jar
sudo cp ./sausage-store-$VERSION.jar /home/jarservice/sausage-store.jar || true #"jar||true" говорит, если команда обвалится — продолжай
sudo mkdir /etc/systemd/system/sausage-store-backend.service.d || true
sudo touch /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo "" > /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="PSQL_HOST=${PSQL_HOST}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="PSQL_PORT=6432"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="PSQL_DBNAME=${PSQL_DBNAME}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="PSQL_USER=${PSQL_USER}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="PSQL_PASSWORD=${PSQL_PASSWORD}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="MONGO_USER=${MONGO_USER}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="MONGO_PASSWORD=${MONGO_PASSWORD}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="MONGO_URL=${MONGO_URL}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo echo 'Environment="MONGO_DATABASE=${MONGO_DATABASE}"' >> /etc/systemd/system/sausage-store-backend.service.d/override.conf
sudo chown -R student:student /home/student/sausage-store.jar
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend
