#!/bin/bash
# Deskon Server Deployment Script for AWS EC2
# Domain: desk.on1.kr

set -e

echo "=== Deskon Server Setup ==="

# 1. Update system
echo "[1/4] Updating system..."
sudo apt update && sudo apt upgrade -y

# 2. Install Docker
echo "[2/4] Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# 3. Install Docker Compose
echo "[3/4] Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo apt install -y docker-compose
fi

# 4. Create data directory
echo "[4/4] Starting services..."
mkdir -p data

# Start containers
sudo docker-compose up -d

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Services running:"
sudo docker ps
echo ""
echo "Important: Make sure these ports are open in AWS Security Group:"
echo "  - TCP 21115 (NAT type test)"
echo "  - TCP 21116 (ID server)"
echo "  - UDP 21116 (ID server)"
echo "  - TCP 21117 (Relay server)"
echo "  - TCP 21118 (Web client support)"
echo "  - TCP 21119 (Web client support)"
echo ""
echo "Your public key will be at: ./data/id_ed25519.pub"
echo ""
