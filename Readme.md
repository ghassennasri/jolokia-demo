To run the demo ;
```sh
./datagen-source.sh
```
As an example, the main script executes a jolokia query 4 times an export the result into files;
curl -X POST http://localhost:8778/jolokia/ -d '{"type":"read", "mbean":"kafka.producer:*"}'

Grafana datasource need to be set to influxDB database "telegraf". Data could then be explored through Grafana explore page. 

- Jolokia is available at http://localhost:8778
- InfluxDB is accessible by logging into influxdb container (docker exec -u -0 -it influxdb influx)
  Database is "telegraf".  
- Grafana is accessible at http://localhost:3000 
- Additional Mbeans could be added to ./conf/telegraf.conf file

References:
* Jolokia protocol: https://jolokia.org/reference/html/protocol.html
* InfluxDB getting started: https://docs.influxdata.com/influxdb/v1.8/introduction/get-started/
* Get started with Grafana and InfluxDB: https://grafana.com/docs/grafana/latest/getting-started/get-started-grafana-influxdb/