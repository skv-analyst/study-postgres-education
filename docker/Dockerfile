FROM postgres:17

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

ENV POSTGRES_USER=demo
ENV POSTGRES_PASSWORD=demo
ENV POSTGRES_DB=demo

COPY init/ /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/*.sh
