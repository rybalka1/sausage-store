# Глава-6 задание №1

## Virtual mashine

+ ip 62.84.118.20

## Single node Postgress

```bash
psql "host=rc1a-k8ywkrkqpew9sfrn.mdb.yandexcloud.net \
      port=6432 \
      sslmode=verify-full \
      dbname=ya-practics \
      user=student \
      target_session_attrs=read-write"
```

+ password: rybalka_dmitrii

## Cluster Postgres

```bash
psql "host=rc1a-ch60xaqh5rz5qhy0.mdb.yandexcloud.net,rc1a-whbdcnkmegsdztzc.mdb.yandexcloud.net \
      port=6432 \
      sslmode=verify-full \
      dbname=ha-ya-practics \
      user=student \
      target_session_attrs=read-write"
```

+ password: ha-rybalka_dmitrii

## MR на сценарии terraform

https://gitlab.praktikum-services.ru/rybalka-dmitrii/terraform/-/merge_requests/3
