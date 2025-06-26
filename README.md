# PostgreSQL. Профессиональный SQL

Этот репозиторий создан для практической работы с книгой ["PostgreSQL. Профессиональный SQL"](https://postgrespro.ru/education/books/advancedsql), которая бесплатно распространяется [PostgresPro](https://postgrespro.ru/).
Репозиторий содержит конфигурацию для быстрого развертывания PostgreSQL 17 в Docker-контейнере c набором данных из книги.


## Быстрый старт
Чтобы начать работу:
1. Установи [Docker](https://www.docker.com/).
2. Подготовь рабочую директорию:
   ```bash
   mkdir pg-book && cd pg-book
   git init
   git clone https://github.com/skv-analyst/postgres-education-db.git
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