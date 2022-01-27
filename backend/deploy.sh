#! /bin/bash
#Если свалится одна из команд, рухнет и весь скрипт
set -xe
#Перезаливаем дескриптор сервиса на ВМ для деплоя
sudo cp -rf ./sausage-store-backend.service /etc/systemd/system/sausage-store-backend.service
sudo cp -rf ./sausage-store-logrotate /etc/logrotate.d/sausage-store-logrotate
sudo mkdir /opt/log |true
sudo cp ./sausage-store-0.0.1-SNAPSHOT.jar $(pwd)/sausage-store.jar||true #"jar||true" говорит, если команда обвалится — продолжай
# sudo chown -R jarservice.jarservice /home/jarservice/sausage-store.jar
#Обновляем конфиг systemd с помощью рестарта
sudo systemctl daemon-reload
#Перезапускаем сервис сосисочной
sudo systemctl restart sausage-store-backend
