# kube-tools

A Docker image to run a few Kubernetes development tools.

## Rationale

This image came out to solve an issue related to build a Golang application that depended upon C shared libraries through [ko](https://github.com/google/ko). While building locally for testing purposes, I needed to build the application using Ko and publish it to a local [Kind](https://kind.sigs.k8s.io/docs/user/quick-start) cluster. However, since I use Archlinux, there were issues regarding certain versions of those shared libraries in my system and the versions expected by the library that depended upon C interop in the Golang application I was writing. Consequentially, after being built, the application has never gotten ready on the Kubernetes cluster.

The better solution I've found was creating this image to run Ko on a Debian-based distro. As a convenience, the image embeds the Docker CLI and Kubectl to interact directly with the Kind cluster. The main disadvantage is that it must run using the docker-out-of-docker (DooD) technique.

## Usage example

```shell
docker run -i --name ko --rm \
  --network host \
  -e GOCACHE=/tmp/go-build \
  -e KO_DOCKER_REPO=kind.local \
  -e KUBE_CONFIG=/root/.kube/config \
  -v /tmp/go-build:/tmp/go-build \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD:$PWD:ro \
  -v $HOME/.kube:/root/.kube:ro \
  -w $PWD \
  alangh/kube-tools ko apply -f app.yaml
```
