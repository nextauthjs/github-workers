# base
FROM ubuntu:latest

# We should probably update these periodically
ARG RUNNER_VERSION=2.277.1
ARG DOCKER_COMPOSE_VERSION=1.28.2

ARG DEBIAN_FRONTEND=noninteractive

RUN \
  # update the base packages and add a non-sudo user
  apt-get update -y && apt-get upgrade -y && useradd -m docker && \
  apt-get install \
  apt-utils dialog -y curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev apt-transport-https ca-certificates gnupg-agent software-properties-common && \
  # install docker
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
  apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io && \
  # install docker-compose
  curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose && \
  # cd into the user directory, download and unzip the github actions runner
  cd /home/docker && mkdir actions-runner && cd actions-runner && \
  curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
  tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
  # install some additional dependencies
  chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
