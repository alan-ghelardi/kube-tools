FROM golang:1.17

# Install the Docker CLI
RUN \
  apt-get update && \
  apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get -y install docker-ce-cli

    # Install Ko
RUN set -eux && \
    export KO_VERSION=0.11.2 && \
    export OS=Linux && \
    export ARCH=x86_64 && \
    curl -L https://github.com/google/ko/releases/download/v${KO_VERSION}/ko_${KO_VERSION}_${OS}_${ARCH}.tar.gz | tar xzf - ko && \
    chmod +x ./ko && \
    mv ./ko /usr/local/bin/

    # Install Kubectl
RUN set -eux && \
  export KUBECTL_VERSION=1.24.2 && \
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

ARG VCS_URL
ARG VCS_REF

LABEL \
  maintainer="Alan Ghelardi <alan.ghelardi@gmail.com>" \
  org.label-schema.schema-version=1.0 \
  org.label-schema.vcs-url="$VCS_URL" \
  org.label-schema.vcs-ref="$VCS_REF"
