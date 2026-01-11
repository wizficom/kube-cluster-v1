### ingress controller
- traefik (k3s default)
- replaced by external nginx proxy manager service
    - [02_deployment.yml](../02_nginx_proxy_manager/02_deployment.yml)
    - Router(80/443) -> NPM -> internal POD(by service host_name) or external server