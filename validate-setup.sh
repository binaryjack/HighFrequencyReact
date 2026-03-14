#!/bin/bash

# Validation script for Docker demo setup

echo "================================================"
echo "  Trading Risk Docker Demo - Validation"
echo "================================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check requirements
echo "Checking prerequisites..."
echo ""

# Check Docker
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker is installed"
    docker --version
else
    echo -e "${RED}✗${NC} Docker is not installed"
    echo "  Install from: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker Compose is installed"
    docker-compose --version
else
    echo -e "${RED}✗${NC} Docker Compose is not installed"
    exit 1
fi

# Check if Docker is running
if docker info &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker daemon is running"
else
    echo -e "${RED}✗${NC} Docker daemon is not running"
    echo "  Please start Docker Desktop"
    exit 1
fi

echo ""
echo "Checking port availability..."
echo ""

# Check ports
check_port() {
    port=$1
    if netstat -tuln 2>/dev/null | grep -q ":$port " || lsof -i:$port &> /dev/null; then
        echo -e "${YELLOW}⚠${NC} Port $port is in use"
        return 1
    else
        echo -e "${GREEN}✓${NC} Port $port is available"
        return 0
    fi
}

ports_ok=true
check_port 3000 || ports_ok=false
check_port 5000 || ports_ok=false
check_port 9200 || ports_ok=false

if [ "$ports_ok" = false ]; then
    echo ""
    echo -e "${YELLOW}Warning:${NC} Some ports are in use. The demo may fail to start."
    echo "You can either:"
    echo "  1. Stop services using these ports"
    echo "  2. Modify ports in docker-compose.yml"
    echo ""
fi

echo ""
echo "Checking file structure..."
echo ""

# Check key files exist
files=(
    "docker-compose.yml"
    "backend/Dockerfile"
    "backend/seed-data.sh"
    "frontend/Dockerfile"
    "frontend/nginx.conf"
)

all_files_exist=true
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file (missing)"
        all_files_exist=false
    fi
done

if [ "$all_files_exist" = false ]; then
    echo ""
    echo -e "${RED}Error:${NC} Some required files are missing"
    exit 1
fi

echo ""
echo "================================================"
echo -e "${GREEN}✓ All prerequisites met!${NC}"
echo "================================================"
echo ""
echo "You can now run:"
echo "  ./start-demo.sh"
echo ""
echo "Or manually:"
echo "  docker-compose up --build -d"
echo ""
