#!/usr/bin/env bash

# 기본 패키지
sudo apt-get update -y
sudo apt-get install -y curl ca-certificates apt-transport-https gnupg lsb-release jq

# 1. Swap 비활성화
sudo swapoff -a
sudo sed -i '/swap/s/^/#/' /etc/fstab

free -h

# 2. 필수 커널 모듈 로드 (즉시 로드 + 부팅 시 로드 설정)
# overlay 모듈과 br_netfilter 모듈을 명시적으로 로드해야 합니다.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 3. sysctl 파라미터 설정 (ip_forward 추가됨)
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 4. 설정 적용
sudo sysctl --system

# local small dns & vagrant cannot parse and delivery shell code.
# echo "192.168.2.10 m-k8s" >> /etc/hosts
# for (( i=1; i<=$1; i++  )); do echo "192.168.2.10$i w$i-k8s" >> /etc/hosts; done

# config DNS  
# cat <<EOF > /etc/resolv.conf
# nameserver 1.1.1.1 #cloudflare DNS
# nameserver 8.8.8.8 #Google DNS
# EOF
