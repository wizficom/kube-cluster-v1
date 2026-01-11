#!/usr/bin/env bash
set -euo pipefail

WORKER_IP="${1:-192.168.0.210}"
MASTER_IP="${2:-192.168.0.70}"
K3S_VERSION="${3:-v1.32.10+k3s1}"

echo "[20_worker] start (WORKER_IP=${WORKER_IP}, MASTER_IP=${MASTER_IP}, K3S_VERSION=${K3S_VERSION})"

# 토큰 생성 대기
# for n in $(seq 1 60); do
#   if [[ -f /vagrant/k3s-node-token ]]; then
#     break
#   fi
#   echo "[20_worker] waiting for /vagrant/k3s-node-token..."
#   sleep 2
# done

# if [[ ! -f /vagrant/k3s-node-token ]]; then
#   echo "[20_worker] ERROR: token not found /vagrant/k3s-node-token"
#   exit 1
# fi

# TOKEN="$(cat /vagrant/k3s-node-token)"
TOKEN="K104b7f6ce802392c038a1179e708557e0685b2a4fd47bf67ee34c3e7c42dfa8cb6::server:5a72241cf5100ab08563571e9a461b6b"

curl -sfL https://get.k3s.io | \
  INSTALL_K3S_VERSION="${K3S_VERSION}" \
  K3S_URL="https://${MASTER_IP}:6443" \
  K3S_TOKEN="${TOKEN}" \
  sh -s - agent \
    --node-ip="${WORKER_IP}"

echo "[20_worker] done"