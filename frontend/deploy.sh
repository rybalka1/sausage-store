#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт

set -xe
VERSION=${VERSION}
#Перезаливаем дескриптор сервиса на ВМ для деплоя

sudo cp -rf sausage-store-frontend.service /etc/systemd/system/sausage-store-frontend.service
sudo rm -rf /home/jarservice/sausage-store||true
sudo rm -rf /home/jarservice/sausage-store-$VERSION||true
#Переносим артефакт в нужную папку
curl -u ${NEXUS_REPO_USER}:${NEXUS_REPO_PASS} -o sausage-store.tar.gz ${NEXUS_REPO_URL}/repository/sausage-store-rybalka-dmitrii-frontend/sausage-store/$VERSION/sausage-store-$VERSION.tar.gz
sudo tar -C /home/jarservice/ -xvzf /home/student/sausage-store.tar.gz
sudo mv /home/jarservice/sausage-store-$VERSION  /home/jarservice/sausage-store
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend
