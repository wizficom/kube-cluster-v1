#!/usr/bin/env bash
set -euo pipefail

MASTER_IP="${1:-192.168.0.70}"
K3S_VERSION="${2:-v1.32.10+k3s1}"  # 필요하면 환경변수로 변경

echo "[10_master] start (MASTER_IP=${MASTER_IP}, K3S_VERSION=${K3S_VERSION})"

curl -sfL https://get.k3s.io | \
  INSTALL_K3S_VERSION="${K3S_VERSION}" \
  sh -s - server \
    --node-ip="${MASTER_IP}" \
    --tls-san="${MASTER_IP}" \
    --write-kubeconfig-mode=644

# workers join 토큰 공유
sudo cat /var/lib/rancher/k3s/server/node-token | sudo tee /vagrant/k3s-node-token >/dev/null

# kubeconfig 공유(옵션)
# sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/k3s.yaml
# sudo chown vagrant:vagrant /vagrant/k3s.yaml

echo "[10_master] done"