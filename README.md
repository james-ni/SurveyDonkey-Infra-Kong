## Summary

To start a Kong server with Konga (a 3rd party UI for Kong) locally,

```shell
docker-compose up
```

This will start

- a PostgreSQL container
- a Kong server container
- a Konga server container
- necessary database migrations

![konga](konga.png)

To restart all containers,

```shell
docker-compose restart
```

To remove all containers,

```shell
docker-compose down
```

To restart a container, e.g. konga

```shell
docker-compose restart konga
```
