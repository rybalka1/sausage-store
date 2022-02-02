#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
VERSION=${VERSION}
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf ./sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
# sudo cp -rf ./sausage-store-logrotate /etc/logrotate.d/sausage-store-logrotate
sudo mkdir /opt/log || true
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.jar ${NEXUS_REPO_URL}//repository/sausage-store-rybalka-dmitrii-backend/com/yandex/practicum/devops/sausage-store/'${VERSION}'/sausage-store-'${VERSION}'.jar

sudo cp ./sausage-store.jar /home/jarservice/sausage-store.jar || true #"jar||true" говорит, если команда обвалится — продолжай
sudo chown -R jarservice.jarservice /home/jarservice/sausage-store.jar
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend
