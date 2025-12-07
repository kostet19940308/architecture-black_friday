# mongo-sharding

## Как запустить

1. Запускаем mongodb и приложение

```shell
docker compose up -d
```

2. Инициализируем шарды и заполняем данные

```shell
./scripts/mongo-init.sh
```

В рамках этого скрипта мы инициализируем configSrv, shard1, shard2; Добавляем shard1, shard2 к mongos_router; Добавляем данные и проверяем кол-во документов на каждом шарде

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Статус кластера

```shell
docker compose exec -T mongos_router mongosh --port 27017 --quiet --eval "sh.status()"
```

### Документов  на shard1:

```shell
docker compose exec -T shard1 mongosh --port 27020 --quiet --eval "use somedb" --eval "db.helloDoc.countDocuments()"
```

### Документов  на shard2:

```shell
docker compose exec -T shard2 mongosh --port 27021 --quiet --eval "use somedb" --eval "db.helloDoc.countDocuments()"
```

### Общее количество документов:

```shell
docker compose exec -T mongos_router mongosh --port 27017 --quiet --eval "use somedb" --eval "db.helloDoc.countDocuments()"
```

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs