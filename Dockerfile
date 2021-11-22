FROM library/postgres

ENV POSTGRES_USER homework
ENV POSTGRES_PASSWORD homework
ENV POSTGRES_DB homework

COPY init.sql /docker-entrypoint-initdb.d/