#!/bin/bash
set +e
#создаем файл для кубера
echo "${KUBECONF}"
echo "${KUBECONF}" | base64 -d > .kube/config
set -e


kubectl apply -f task9-3/backend
kubectl apply -f task9-3/backend-report
kubectl apply -f task9-3/frontend
#удаляем файл конфига для кубера
rm .kube/config
