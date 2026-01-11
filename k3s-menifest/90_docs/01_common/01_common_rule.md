### 필수 필드 (Root Fields)
```bash
# 1. API 버전 (리소스 종류에 따라 다름)
apiVersion: apps/v1 

# 2. 리소스 종류
kind: Deployment

# 3. 메타데이터 (식별 정보)
metadata:
  name: my-web-server        # [중요] 해당 Namespace 내에서 유일해야 함
  namespace: default         # 생략 시 'default'로 지정됨
  labels:                    # 검색이나 연결을 위한 태그
    app: nginx-app

# 4. 스펙 (원하는 상태 상세)
spec:
```

### Resource id
- Unique Key = Namespace + Kind + Name
- (예: default 네임스페이스에 있는 Deployment 종류의 nginx라는 이름)