# NextAuth.js GitHub Actions workers 👷

## Prerequisities

1. Get Personal Access Token (PAT) with "repo" and "workflow" scope: https://github.com/settings/tokens
2. Create .env.local
3. add `ACCESS_TOKEN=PASTE_PAT_HERE`

## Build image

```sh
docker build --tag runner .
```

## Run container

### Single
#### Run
```sh
docker run \
  --detach \
  --env-file ".env.local" \
  --name runner \
  runner
```

#### Stop
```sh
docker stop runner
docker rm runner
```

### Swarm

#### Build Docker Compose
```sh
docker-compose build
```

#### Start 3 runners
```sh
docker-compose up --scale runner=3 -d
```
#### Stop
```sh
docker-compose down runner
```

# Thanks / More info
https://testdriven.io/blog/github-actions-docker/


