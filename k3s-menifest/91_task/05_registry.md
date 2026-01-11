### Registry
- Docker Distribution (기본 Docker Registry) + registry-ui
    - [docker-registry.yml](../30_docker_reg/docker-registry.yml)
- Harbor
- Nexus Repository OSS

### Image Architecture
- build/push 시에 Multi Architecture 고려 필요
    - arm64(RPi, M1 Mac)
    - amd64(amd64)