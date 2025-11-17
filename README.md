# PostgreSQL. Профессиональный SQL

## Зачем
Репозиторий содержит конфигурацию для быстрого развёртывания PostgreSQL 17 в Docker-контейнере с набором данных из [демонстрационной базы данных](https://postgrespro.ru/education/demodb). Он предназначен для практической работы с бесплатно распространяемыми книгами от PostgresPro:
1. ["PostgreSQL. Основы языка SQL"](https://postgrespro.ru/education/books/sqlprimer) 
2. ["PostgreSQL. Профессиональный SQL"](https://postgrespro.ru/education/books/advancedsql)

## Быстрый старт
Чтобы начать работу:
1. Установи [Docker](https://www.docker.com/).
2. Подготовь рабочую директорию:
   ```bash
   mkdir pg-book && cd pg-book
   git init
   git clone https://github.com/skv-analyst/study-postgres-education.git
   cd postgres-education-db
   ```
3. Запусти контейнер:
    ```bash
    docker-compose up -d
    ```
4. Проверь, что контейнер работает. В выводе команды будет работающий контейнер с открытым портом (5432).
    ```bash
    docker ps -a
    ```

## Подключение к базе данных
Через любой GUI-клиент (DBeaver, pgAdmin, DataGrip и др.):
- Host: `localhost`
- Port: `5432`
- Database: `demo`
- Username: `demo`
- Password: `demo`
