# mongo-sharding

## Как запустить

1. Запускаем mongodb и приложение

```shell
docker compose up -d
```

2. Инициализируем шарды, реплики и заполняем их  данные

```shell
./scripts/mongo-init.sh
```

В рамках этого скрипта мы инициализируем configSrv, shard1_1, shard2_1(первичные узлы), shard1_2, shard1_3, shard2_2, shard2_3(вторичные узлы); Создаем ReplicaSet shard1 и shard2; Добавляем shard1, shard2 к mongos_router; Добавляем данные и проверяем кол-во документов на каждом шарде

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Статус кластера

```shell
docker compose exec -T mongos_router mongosh --port 27017 --quiet --eval "sh.status()"
```

### Статус shard1:

```shell
docker compose exec -T shard1_1 mongosh --port 27020 --quiet --eval "use somedb" --eval "rs.status()"
```

### Статус shard2:

```shell
docker compose exec -T shard2_1 mongosh --port 27021 --quiet --eval "use somedb" --eval "rs.status()"
```

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs