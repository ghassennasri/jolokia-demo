To run the demo ;
```sh
./datagen-source.sh
```
As an example, the main script executes a jolokia query 4 times an export the result into files;
curl -X POST http://localhost:8778/jolokia/ -d '{"type":"read", "mbean":"kafka.producer:*"}'

- Jolokia is available at http://localhost:8778
- InfluxDB is accessible by logging into influxdb container (docker exec -u -0 -it influxdb influx)
  Database is "telegraf".  
- Grafana is accessible at http://localhost:3000 
- Additional Mbeans could be added to ./conf/telegraf.conf file