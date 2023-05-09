# paper

`docker-compose.yml`
```yml
version: '3'

services:

  paper:
    container_name: paper
    image: ghcr.io/yudejp/paper-docker:master
    network_mode: host
    volumes:
      - ./paper:/app
    tty: true
    stdin_open: true
    environment:
      JAVA_OPTS: "-Xms1G -Xmx2G"
```

## LICENSE
MIT License
