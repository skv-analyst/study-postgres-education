# PostgreSQL 17 + Demo Database
- [Book](https://postgrespro.ru/education/books/advancedsql)

## Prerequisites
- Docker installed

## Running the database

1. Clone this repository:
    ```bash
    git init
    git clone https://github.com/skv-analyst/postgres-education-db.git
    ```

2. Build and run the container:
   ```bash
   cd postgres-education-db
   docker-compose up -d
   ```
   
3. Verify container is running:
   ```bash
   docker ps -a
   ```


### Connection details
- Host: `localhost`
- Port: `5432`
- Database: `demo`
- Username: `demo`
- Password: `demo`
