## RPI Kubernetes Cluster

### Bare Metal Configuration
- Master Node (Control Plane)
    - RPi5 1EA / NVME (NFS for PV) 
- Worker Node
    - RPi4 3EA
    - AMD 8745hs Server 1EA
    - M1 Mac (Linux VM) 1EA

### Install k3s
- [Master](k3s-install/master/10_master_node.sh)
- [Worker](k3s-install/worker/20_worker_node.sh)

### Basic Setup
- Package Manger 
    - [01_package_helm.md](k3s-menifest/91_task/01_package_helm.md)
- Ingress Controller
    - [02_ingress.md](k3s-menifest/91_task/02_ingress.md)
- Metal LB
    - [03_metal_lb.md](k3s-menifest/91_task/03_metal_lb.md)
- PVC Provisioner
    - [04_pvc_provisioner.md](k3s-menifest/91_task/04_pvc_provisioner.md)
- Registry
    - [05_registry.md](k3s-menifest/91_task/05_registry.md)
- Backup
    - [20_backup.md](k3s-menifest/91_task/20_backup.md)