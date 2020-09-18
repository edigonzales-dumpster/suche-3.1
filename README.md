# suche-3.1

## Entwicklung

### (Geo-)Datenbank  
```
docker run --rm --name pub-db -p 54322:5432 --hostname primary -e PG_DATABASE=pub -e PG_LOCALE=de_CH.UTF-8 -e PG_PRIMARY_PORT=5432 -e PG_MODE=primary -e PG_USER=admin -e PG_PASSWORD=admin -e PG_PRIMARY_USER=repl -e PG_PRIMARY_PASSWORD=repl -e PG_ROOT_PASSWORD=secret -e PG_WRITE_USER=gretl -e PG_WRITE_PASSWORD=gretl -e PG_READ_USER=ogc_server -e PG_READ_PASSWORD=ogc_server -v ~/pgdata-suche_drei_eins:/pgdata:delegated sogis/oereb-db:latest
```

```
java -jar /Users/stefan/apps/ili2pg-4.4.2/ili2pg-4.4.2.jar --dbhost localhost --dbport 54322 --dbdatabase pub --dbusr admin --dbpwd admin --defaultSrsCode 2056 --disableValidation --strokeArcs --createEnumTabs --models SO_AGI_MOpublic_20190424 --createGeomIdx --nameByTopic --dbschema agi_mopublic_pub --postScript postscript.sql --schemaimport

java -jar /Users/stefan/apps/ili2pg-4.4.2/ili2pg-4.4.2.jar --dbhost localhost --dbport 54322 --dbdatabase pub --dbusr admin --dbpwd admin --defaultSrsCode 2056 --disableValidation --strokeArcs --createEnumTabs --models SO_AGI_MOpublic_20190424 --createGeomIdx --nameByTopic --dbschema agi_mopublic_pub --import /Users/stefan/Downloads/ch.so.agi_mopublic_xtf/ch.so.agi_mopublic_2020-09-08.xtf

```