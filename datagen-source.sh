#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


NOW="$(date +%s)000"
sed -e "s|:NOW:|$NOW|g" \
    ${DIR}/schemas/orders-template.avro > ${DIR}/schemas/orders.avro
sed -e "s|:NOW:|$NOW|g" \
    ${DIR}/schemas/shipments-template.avro > ${DIR}/schemas/shipments.avro

docker-compose -f "${PWD}/docker-compose.yml" up -d
sleep 60

echo -e "Create topic orders\n"
curl -s -X POST \
      -H "Content-Type: application/json" \
      --data '{
                "name": "gna_datagen",
                "config": {
                "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
                "kafka.topic": "orders",
                "key.converter": "org.apache.kafka.connect.storage.StringConverter",
                "value.converter": "org.apache.kafka.connect.json.JsonConverter",
                "value.converter.schemas.enable": "false",
                "max.interval": 2000,
                 "iterations": "1000",
                "tasks.max": "1",
                "schema.filename" : "/tmp/schemas/orders.avro",
                "schema.keyfield" : "orderid"
               
                }
            }' \
      http://localhost:8083/connectors | jq



# "producer.override.client.id":"gna_dg-producer",


sleep 10

echo -e "Verify we have received the data in orders topic\n"
timeout 60 docker exec broker kafka-console-consumer --bootstrap-server broker:9092 --topic orders --from-beginning --max-messages 1



echo  -e "export producer kafka connect metrics from jolokia\n"
for i in {1..4}
do 
curl -X POST http://localhost:8778/jolokia/ -d '{"type":"read", "mbean":"kafka.producer*:client-id=connector-producer-gna_datagen-0,type=producer-metrics,*"}' | jq > metrics_export${i}.txt
echo  -e "exported metrics_export${i}.txt\n"

sleep 10
done
