### NFS Provisioner 설치
```bash
# Helm 리포지토리 추가
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm repo update

# Provisioner 설치
helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=192.168.0.100 \
  --set nfs.path=/srv/nfs/kubedata \
  --set storageClass.name=nfs-client \
  --set storageClass.defaultClass=true
```