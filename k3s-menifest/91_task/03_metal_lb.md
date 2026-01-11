### metal lb 설치
- Default LoadBalancer
    - 기존 LoadBalancer(servicelb) 편의상 off
        ```bash
        # /etc/rancher/k3s/config.yaml 설정 파일 변경
        disable:
        - servicelb
        ```  

- metal lb package 설치
    ```bash
    sudo systemctl restart k3s

    # MetalLB 설치
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-native.yaml

    # 설치 확인
    kubectl get pods -n metallb-system

    # metallb-config.yaml 실행
    ```

- metal lb config
    - Router(공유기)의 DHCP 할당 대역대 제외 설정 필요
    - IPAddressPool
        <details>
        <summary><u>🔽 예제 코드 </u></summary>

        ```bash
        apiVersion: metallb.io/v1beta1
        kind: IPAddressPool
        metadata:
            name: first-pool
            namespace: metallb-system
        spec:
            addresses:
            - 192.168.0.230-192.168.0.239  # [수정필요] 사용할 IP 범위
        ```
        </details>
    - L2Advertisement
        <details>
        <summary><u>🔽 예제 코드 </u></summary>

        ```bash
        apiVersion: metallb.io/v1beta1
        kind: L2Advertisement
        metadata:
            name: homelab-l2
            namespace: metallb-system
        spec:
            ipAddressPools:
            - first-pool
        ```
        </details>