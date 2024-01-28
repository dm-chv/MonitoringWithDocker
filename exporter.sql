CREATE USER 'exporter'@'%' IDENTIFIED BY 'superpass';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
GRANT SELECT ON performance_schema.* TO 'exporter'@'%';