# Homework - Thanh Tran

## Prerequisites
- Docker

## Installation

Build a docker image

```
docker build -t homework .
```

## Usage
Run docker container, publish port `5432` for the first time:
```
docker run --name=homework -p 5433:5432 homework
```
OR start a stopped container:
```
docker start homework
```
Now, you can access to this Postgres container via port `5432` or run command directly inside container using:
```
docker exec -it homework bash
```

ENV:
```
POSTGRES_USER: homework
POSTGRES_PASSWORD: homework
POSTGRES_DB: homework
```