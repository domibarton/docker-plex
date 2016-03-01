## About

This is a Docker image for the [Plex Media Server](http://plex.tv/).

The Docker image currently supports:

* running Plex under its __own user__ (not `root`)
* changing of the __UID and GID__ for the Plex user

## Run

### Run via Docker CLI client

To run the Plex container you can execute:

```bash
docker run --name plex -v <config path>:/config -v <media path>:/media -p 32400:32400 dbarton/plex
```

Open a browser and point it to [http://my-docker-host:32400](http://my-docker-host:32400)

### Run via Docker Compose

You can also run the Plex container by using [Docker Compose](https://www.docker.com/docker-compose).

If you've cloned the [git repository](https://github.com/domibarton/docker-plex) you can build and run the Docker container locally (without the Docker Hub):

```bash
docker-compose up -d
```

If you want to use the Docker Hub image within your existing Docker Compose file you can use the following YAML snippet:

```yaml
plex:
    image: "dbarton/plex"
    container_name: "plex"
    volumes:
        - "<config path>:/config"
        - "<media path>:/media"
    ports:
        - "32400:32400"
    restart: always
```

## Configuration

### Volumes

Please mount the following volumes inside your Plex container:

* `/config`: Holds all the Plex configuration files (usually `/Library/Application Support`)
* `/media`: Directory for media
* `/transcode`: Temporary directory for transcoding _(optional)_

### UID and GID

By default Plex runs with user ID and group ID `666`.
If you want to run Plex with different ID's you've to set the `PLEX_UID` and/or `PLEX_GID` environment variables, for example:

```
PLEX_UID=1234
PLEX_GID=1234
```