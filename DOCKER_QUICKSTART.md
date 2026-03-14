# Docker Compose Demo - One Command Demo

## Quick Start

### Windows:
```powershell
.\start-demo.ps1
```

### Linux/Mac:
```bash
chmod +x start-demo.sh
./start-demo.sh
```

### Manual:
```bash
docker-compose up --build -d
```

## What You Get

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **OpenSearch**: http://localhost:9200
- **1000 seeded records** ready to explore

## Services Overview

```
┌─────────────────┐
│   Frontend      │  Port 3000
│   (React + AG   │  Nginx
│    Grid)        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Backend API   │  Port 5000
│   (.NET 8)      │  RESTful API
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   OpenSearch    │  Port 9200
│   (Data Store)  │  1000 records
└─────────────────┘
```

## Stop Services

```bash
# Stop (keeps data)
docker-compose down

# Stop + remove data
docker-compose down -v
```

## Troubleshooting

See [DOCKER.md](DOCKER.md) for detailed troubleshooting guide.

### Quick Checks:

**Check containers:**
```bash
docker-compose ps
```

**Check logs:**
```bash
docker-compose logs -f backend
```

**Verify data:**
```bash
curl http://localhost:9200/risk-aggregates/_count
```

## Requirements

- Docker Desktop
- 4GB+ RAM available
- Ports 3000, 5000, 9200 free
