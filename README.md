# Инструкция по разворачиванию системы мониторинга средствами Docker

## Системные требования:

* grafana, nginx, prometheus – последние стабильные версии
* docker, docker compose
* debian 12 
* MariaDB

## Подготовка сервера. Установка Docker.
  
```
sudo apt update
sudo apt install docker docker.io docker-compose
```

## Изменяемые данные / Переменные:

| расположение переменной | имя переменной | функционал переменной |
|-------------------------|----------------|-----------------------|
|config.my-cnf            | user | Имя пользователя для подключения mysqld_exporter к MariaDB|
|config.my-cnf            | password | Пароль для подключения mysqld_exporter к MariaDB|
|config.my-cnf            | host | Хост базы данных|
|exporter.sql             | |Создаваемый пользователь должен быть таким, как в файле config.my-cnf |
|nginx.conf               | |Возможна смена стандартного http порта и проксирование запросов на другой адрес |
|prometheus.yml           | |Возможна смена или добавление других источников данных |

## Описание файлов

* config.my-cnf - Конфигурационный файл для mysqld_exporter
* docker-compose.yaml - Описание всех Docker контейнеров и их установка
* exporter.sql - sql запрос на создание пользователя для сбора метрик из базы данных
* nginx.conf - Конфигурационный файл веб сервера
* prometheus.yml - Конфигурационный файл сборщика метрик, с описанием откуда брать метрики
* Mysql.json - Дашборд мониторинга базы данных для импорта в Grafana
* OS General.json - Дашборд мониторинга хост системы для импорта в Grafana

## Описание docker-compose.yaml

*Данный файл содержит в себе описание установки шести доекер контейнеров:*

* prometheus - сборщик метрик.
* grafana - постороение графиков на основе данных из prometheus.
* nginx - проксирует запросы со стандартного порта 80 на контейнер с grafana.
* node-exporter - экспортирует метрики из хостовой системы в формате понятном для prometheus.
* mysql-exporter - экспортирует метрики из сервера mysql в формате понятном для prometheus.
* mariadb - база данных, которую нужно мониторить.

#

## Разворачивание системы мониторинга
1. Клонируем данный репозиторий,(git clone)
2. Запускаем ```sudo docker-compose up -d ```
3. Настройка Grafana
* Grafana доступна по http протоколу на ip адресе хоста на стандартонм порту 80  
* При первом посещении нужно будет сменить пароль. Стандартный логин/пароль - admin/admin  
* Необходимо привязать Grafana к Prometheus:
```
Home -> Connections -> Data sources -> prometheus
Connection -> http://prometheus:9090  -> Save&test
```
* После можем приступать к добавлению дашбордов 'Mysql.json' и 'OS General.json'.