* ConfigMap: Static Config Text

### Volume Mapping 방법
* 정적 프로비저닝: PV 수동 생성
* 동적 프로비저닝: StorageClass(Provisioner) 를 통한 PV 자동 생성
* PV에서 HostPath 직접연결
    <details>
    <summary><u>🔽 예제 코드 </u></summary>

    ```bash
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: nginx-local-pv
    spec:
      capacity:
        storage: 1Gi
      accessModes:
        - ReadWriteOnce
      hostPath:
        path: "/home/user/my-web" # [중요] 실제 K3s 서버에 존재하는 폴더 경로
        type: DirectoryOrCreate     # 폴더가 없으면 자동 생성

    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: nginx-html-pvc
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
      volumeName: nginx-local-pv # 위에서 만든 PV를 콕 집어서 연결

    ---
    # Deployment는 동일 (volumes 부분에서 claimName: nginx-html-pvc 사용)
    ```

    </details>
* 인라인 볼륨
    - PV/PVC 리소스를 만들지 않고, Deployment 에서 HostPath 직접 명시

### ConfigMap
- ConfigMap 생성: 원하는 HTML 내용을 담은 ConfigMap을 정의합니다.

- Volume 설정: Pod(Deployment)에서 해당 ConfigMap을 Volume으로 잡습니다.

- Volume Mount: 컨테이너 내부의 /usr/share/nginx/html 경로에 해당 Volume을 마운트합니다.
    <details>
    <summary><u>🔽 예제 코드 </u></summary>

    ```bash
    apiVersion: v1
    kind: ConfigMap
    metadata:
    name: nginx-index-html-config
    data:
    index.html: |
        <!DOCTYPE html>
        <html>
        <head>
        <title>K3s Nginx ConfigMap</title>
        </head>
        <body>
        <h1>Hello from ConfigMap!</h1>
        <p>This index.html is mounted via Kubernetes ConfigMap.</p>
        </body>
        </html>

    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: nginx-deployment
    labels:
        app: nginx
    spec:
    replicas: 2
    selector:
        matchLabels:
        app: nginx
    template:
        metadata:
        labels:
            app: nginx
        spec:
        containers:
        - name: nginx
            image: nginx:latest
            ports:
            - containerPort: 80
            # [3] 컨테이너 내부 경로에 마운트
            volumeMounts:
            - name: html-volume
            mountPath: /usr/share/nginx/html
        # [2] ConfigMap을 Volume으로 정의
        volumes:
        - name: html-volume
            configMap:
            name: nginx-index-html-config

    ---
    apiVersion: v1
    kind: Service
    metadata:
    name: nginx-service
    spec:
    selector:
        app: nginx
    ports:
        - protocol: TCP
        port: 8090
        targetPort: 80
    type: LoadBalancer
    ```  


- Volume File Mount: 특정 파일만 교체
    <details>
    <summary><u>🔽 예제 코드 </u></summary>

    ```bash
    apiVersion: v1
    kind: ConfigMap
    metadata:
    name: nginx-multi-file-config
    data:
    # [파일 1] index.html
    index.html: |
        <!DOCTYPE html>
        <html>
        <head><title>Home</title></head>
        <body>
        <h1>Main Page</h1>
        <p>Click here to go to <a href="about.html">About Page</a></p>
        </body>
        </html>

    # [파일 2] about.html (추가된 파일)
    about.html: |
        <!DOCTYPE html>
        <html>
        <head><title>About</title></head>
        <body>
        <h1>About Page</h1>
        <p>This is the second file from ConfigMap!</p>
        </body>
        </html>
    ---

    ...
    volumeMounts:
        # 첫 번째 파일 매핑 (index.html)
        - name: html-volume
          mountPath: /usr/share/nginx/html/index.html  # 컨테이너 안의 전체 경로 (파일명 포함)
          subPath: index.html                           # ConfigMap의 Key 이름

        # 두 번째 파일 매핑 (about.html)
        - name: html-volume
          mountPath: /usr/share/nginx/html/about.html   # 컨테이너 안의 전체 경로 (파일명 포함)
          subPath: about.html                           # ConfigMap의 Key 이름

    ```

### PVC/PV
- 구성요소: PVC, PV, StorageClass
- 동적 프로비저닝
    - PVC 생성 - StorageClass 지정 -> Provisioner 가 자동으로 PV 생성
    -
        <details>
        <summary><u>🔽 예제 코드 </u></summary>

        ```bash
        apiVersion: v1
        kind: PersistentVolumeClaim
        metadata:
        name: auto-pvc
        spec:
        accessModes:
            - ReadWriteOnce
        storageClassName: local-path  # [핵심] K3s의 자동 생성 Provisioner를 지정
        resources:
            requests:
            storage: 1Gi
        ```

        </details>

- 정적 프로비저닝
    - PV 생성
        - Provisioner 없이 특정 폴더나 특정 nfs주소 등 직접 지정
    - PVC 연결
    - 
        <details>
        <summary><u>🔽 예제 코드 </u></summary>

        ```bash
        apiVersion: v1
        kind: PersistentVolume
        metadata:
        name: manual-pv
        labels:
            type: local
        spec:
        storageClassName: manual # [중요] PVC와 짝을 맞추기 위한 이름
        capacity:
            storage: 1Gi
        accessModes:
            - ReadWriteOnce
        hostPath:
            path: "/data/nginx-html" # 호스트의 실제 경로
        # nfs: 
            # server: 192.168.1.100
            # path: "/data/nfs-share/my-specific-folder"
        nodeAffinity:
            ...
        ---
        apiVersion: v1
        kind: PersistentVolumeClaim
        metadata:
        name: manual-pvc
        spec:
        storageClassName: manual # [중요] 위 PV의 storageClassName과 일치해야 함
        accessModes:
            - ReadWriteOnce
        resources:
            requests:
            storage: 1Gi
        selector: # (선택사항) 라벨로 더 명확하게 매칭 가능
            matchLabels:
      type: local
        ```    

        </details>
- 

### StorageClass
- Provisioner 설치
    - 가장 많이 쓰는 것: Rancher Local Path Provisioner, NFS Subdir External Provisioner, Rook Ceph, Longhorn, OpenEBS 등
    - 예: NFS를 이용해 PV를 자동으로 찍어내는 Provisioner를 헬름(Helm) 등으로 설치합니다.
- StorageClass 생성
- 
    <details>
        <summary><u>🔽 예제 코드 </u></summary>

        ```bash
        apiVersion: storage.k8s.io/v1
        kind: StorageClass
        metadata:
        name: nfs-client
        provisioner: k8s-sigs.io/nfs-subdir-external-provisioner # [중요] 설치한 요리사 이름
        parameters:
        archiveOnDelete: "false"
        ```
    </details>
- PVC 생성: 이제 storageClassName: nfs-client로 PVC를 만들면 PV가 자동 생성됩니다.
- [선택] 저장 경로 변경하기 (ConfigMap 수정)