# Deskon AWS 배포 가이드

desk.on1.kr 서버 배포를 위한 단계별 가이드입니다.

---

## 1단계: AWS EC2 인스턴스 생성

### AWS 콘솔 접속
1. https://aws.amazon.com 접속
2. 콘솔에 로그인

### EC2 인스턴스 생성
1. **EC2** 검색 → 클릭
2. **인스턴스 시작** 버튼 클릭
3. 설정:
   - **이름**: `deskon-server`
   - **OS**: Ubuntu Server 22.04 LTS (프리티어 가능)
   - **인스턴스 유형**: t2.micro (프리티어) 또는 t3.small (추천)
   - **키 페어**: 새로 생성 또는 기존 선택 (SSH 접속용)
   - **네트워크 설정**: "인터넷에서 SSH 트래픽 허용" 체크

4. **인스턴스 시작** 클릭

---

## 2단계: 보안 그룹 설정 (포트 열기)

1. EC2 대시보드 → **보안 그룹** 클릭
2. 방금 만든 인스턴스의 보안 그룹 선택
3. **인바운드 규칙 편집** 클릭
4. 다음 규칙 추가:

| 유형 | 포트 | 소스 | 설명 |
|------|------|------|------|
| 사용자 지정 TCP | 21115 | 0.0.0.0/0 | NAT 테스트 |
| 사용자 지정 TCP | 21116 | 0.0.0.0/0 | ID 서버 (TCP) |
| 사용자 지정 UDP | 21116 | 0.0.0.0/0 | ID 서버 (UDP) |
| 사용자 지정 TCP | 21117 | 0.0.0.0/0 | 릴레이 서버 |
| 사용자 지정 TCP | 21118 | 0.0.0.0/0 | 웹 클라이언트 |
| 사용자 지정 TCP | 21119 | 0.0.0.0/0 | 웹 클라이언트 |

5. **규칙 저장** 클릭

---

## 3단계: 도메인 연결 (desk.on1.kr)

DNS 설정에서 A 레코드 추가:
- **호스트**: desk
- **값**: EC2 퍼블릭 IP 주소 (예: 54.123.456.78)
- **TTL**: 300

---

## 4단계: 서버 접속 및 배포

### SSH로 서버 접속
```bash
# 키 파일 권한 설정
chmod 400 your-key.pem

# 서버 접속
ssh -i your-key.pem ubuntu@desk.on1.kr
```

### 배포 스크립트 실행
```bash
# 파일 다운로드
mkdir deskon && cd deskon

# docker-compose.yml 생성
cat > docker-compose.yml << 'EOF'
version: '3'

services:
  hbbs:
    container_name: hbbs
    image: rustdesk/rustdesk-server:latest
    command: hbbs -r desk.on1.kr:21117
    volumes:
      - ./data:/root
    network_mode: host
    depends_on:
      - hbbr
    restart: unless-stopped

  hbbr:
    container_name: hbbr
    image: rustdesk/rustdesk-server:latest
    command: hbbr
    volumes:
      - ./data:/root
    network_mode: host
    restart: unless-stopped
EOF

# Docker 설치
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# 재접속 (docker 그룹 적용)
exit
```

### 다시 접속 후 실행
```bash
ssh -i your-key.pem ubuntu@desk.on1.kr
cd deskon

# 서버 시작
docker-compose up -d

# 상태 확인
docker ps
```

---

## 5단계: 확인

### 서버 상태 확인
```bash
docker ps
```

출력 예시:
```
CONTAINER ID   IMAGE                             STATUS         PORTS     NAMES
abc123         rustdesk/rustdesk-server:latest   Up 2 minutes             hbbs
def456         rustdesk/rustdesk-server:latest   Up 2 minutes             hbbr
```

### 공개키 확인
```bash
cat data/id_ed25519.pub
```

이 키는 앱에서 서버 인증에 사용됩니다.

### 로그 확인
```bash
docker logs hbbs
docker logs hbbr
```

---

## 6단계: 앱에서 연결 테스트

Deskon 앱을 실행하면 자동으로 desk.on1.kr 서버에 연결됩니다.
(서버 주소가 앱에 하드코딩되어 있음)

---

## 유용한 명령어

```bash
# 서버 재시작
docker-compose restart

# 서버 중지
docker-compose down

# 서버 로그 실시간 보기
docker-compose logs -f

# 서버 업데이트
docker-compose pull
docker-compose up -d
```

---

## 비용 참고

| 항목 | 비용 (월) |
|------|----------|
| EC2 t2.micro (프리티어) | 무료 (1년) |
| EC2 t3.small | ~$15 |
| 데이터 전송 | 사용량에 따라 |

프리티어 기간(1년)에는 t2.micro로 무료 운영 가능합니다.

---

## 문제 해결

### 연결 안 됨
1. 보안 그룹 포트 확인
2. `docker ps`로 컨테이너 실행 확인
3. `docker logs hbbs` 로그 확인

### 도메인 연결 안 됨
1. DNS 설정 확인 (A 레코드)
2. `nslookup desk.on1.kr`로 DNS 확인
3. DNS 전파 대기 (최대 48시간, 보통 10분)
