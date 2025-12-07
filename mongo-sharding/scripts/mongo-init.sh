#!/bin/bash

echo "инициализация кластера mongo-sharding"

echo "инициализация configSvr"
docker compose exec -T configSvr mongosh --port 27019 --quiet <<EOF
rs.initiate({
    _id: "configSvr",
    configsvr: true,
    members: [
        { _id: 0, host: "configSvr:27019" }
    ]
})
EOF

echo "инициализация shard1"
docker compose exec -T shard1 mongosh --port 27020 --quiet <<EOF
rs.initiate({
    _id: "shard1",
    members: [
        { _id: 0, host: "shard1:27020" }
    ]
})
EOF

echo "инициализация shard2"
docker compose exec -T shard2 mongosh --port 27021 --quiet <<EOF
rs.initiate({
    _id: "shard2",
    members: [
        { _id: 0, host: "shard2:27021" }
    ]
})
EOF

sleep 10

echo "инициализация mongos_router и добавление данных"
docker compose exec -T mongos_router mongosh --port 27017 --quiet <<EOF
sh.addShard("shard1/shard1:27020")
sh.addShard("shard2/shard2:27021")
sh.enableSharding("somedb")

use somedb
db.helloDoc.createIndex({name:1})
sh.shardCollection("somedb.helloDoc", { name: "hashed"})

for(var i = 0; i < 2000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF

sleep 5

echo "Количество документов на shard1:"
docker compose exec -T shard1 mongosh --port 27020 --quiet <<EOF
use somedb
var shard1Count = db.helloDoc.countDocuments()
print("Документов на shard1rs:", shard1Count)
EOF

echo "Количество документов на shard2:"
docker compose exec -T shard2 mongosh --port 27021 --quiet <<EOF
use somedb
var shard2Count = db.helloDoc.countDocuments()
print("Документов на shard2rs:", shard2Count)
EOF