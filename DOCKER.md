# Docker Demo Guide

## Prerequisites

- Docker Desktop installed and running
- At least 4GB RAM available for Docker
- Ports 3000, 5000, 9200 available

## Quick Start

### Windows (PowerShell):
```powershell
.\start-demo.ps1
```

### Linux/Mac:
```bash
chmod +x start-demo.sh
./start-demo.sh
```

### Manual Start:
```bash
docker-compose up --build -d
```

## What Gets Started

1. **OpenSearch** (port 9200)
   - Single-node cluster
   - 512MB heap size
   - No security plugin (demo only)

2. **Data Seeder** (one-time container)
   - Creates `risk-aggregates` index
   - Seeds 1000 sample records
   - Automatically exits after completion

3. **Backend API** (port 5000)
   - .NET 8 Web API
   - Connected to OpenSearch
   - RESTful endpoints

4. **Frontend** (port 3000)
   - React 18 + AG Grid
   - Nginx web server
   - Connected to backend

## Access Points

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:3000 | Main application UI |
| **Backend API** | http://localhost:5000/api/RiskAggregates | REST API endpoint |
| **OpenSearch** | http://localhost:9200 | Direct database access |
| **Swagger UI** | http://localhost:5000/swagger | API documentation |

## Verify Setup

### Check all containers running:
```bash
docker-compose ps
```

Expected output:
```
NAME                  STATUS    PORTS
trading-frontend      Up        0.0.0.0:3000->80/tcp
trading-backend       Up        0.0.0.0:5000->80/tcp
trading-opensearch    Up        0.0.0.0:9200->9200/tcp
trading-seeder        Exited 0
```

### Check data was seeded:
```bash
curl http://localhost:9200/risk-aggregates/_count
```

Should return approximately 1000 documents.

### Test backend API:
```bash
curl -X POST http://localhost:5000/api/RiskAggregates \
  -H "Content-Type: application/json" \
  -d '{"startRow":0,"endRow":10}'
```

### Test frontend:
Open browser to http://localhost:3000

## Useful Commands

### View logs:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f opensearch
docker-compose logs seeder
```

### Restart a service:
```bash
docker-compose restart backend
docker-compose restart frontend
```

### Rebuild after code changes:
```bash
docker-compose up --build -d backend
docker-compose up --build -d frontend
```

### Stop all services:
```bash
docker-compose down
```

### Stop and remove all data:
```bash
docker-compose down -v
```

### Enter a container:
```bash
docker exec -it trading-backend /bin/bash
docker exec -it trading-frontend /bin/sh
```

## Troubleshooting

### OpenSearch won't start:
```bash
# Check logs
docker-compose logs opensearch

# Increase Docker memory to 4GB+
# Docker Desktop -> Settings -> Resources -> Memory

# Remove old volumes
docker-compose down -v
docker-compose up -d opensearch
```

### Backend can't connect to OpenSearch:
```bash
# Verify OpenSearch is healthy
curl http://localhost:9200/_cluster/health

# Check backend logs
docker-compose logs backend

# Restart backend
docker-compose restart backend
```

### Frontend shows connection refused:
```bash
# Check backend is running
curl http://localhost:5000/api/RiskAggregates

# Check CORS settings
docker-compose logs backend | grep CORS

# Rebuild frontend
docker-compose up --build -d frontend
```

### Data not seeded:
```bash
# Check seeder logs
docker-compose logs seeder

# Re-run seeder manually
docker-compose up seeder

# Or seed manually from host
./backend/seed-opensearch.ps1  # Windows
./backend/seed-opensearch.sh   # Linux/Mac
```

### Port already in use:
```bash
# Find what's using the port (Windows)
netstat -ano | findstr :3000
netstat -ano | findstr :5000
netstat -ano | findstr :9200

# Find what's using the port (Linux/Mac)
lsof -i :3000
lsof -i :5000
lsof -i :9200

# Change ports in docker-compose.yml if needed
```

## Development Workflow

### Make backend changes:
1. Edit code in `backend/src/`
2. Rebuild: `docker-compose up --build -d backend`
3. Test: `curl http://localhost:5000/api/RiskAggregates`

### Make frontend changes:
1. Edit code in `frontend/src/`
2. Rebuild: `docker-compose up --build -d frontend`
3. Test: Open http://localhost:3000

### Re-seed data:
```bash
docker-compose up seeder
```

## Performance Tips

1. **Use BuildKit** for faster builds:
   ```bash
   $env:DOCKER_BUILDKIT=1  # PowerShell
   export DOCKER_BUILDKIT=1  # Bash
   ```

2. **Prune unused images** periodically:
   ```bash
   docker system prune -a
   ```

3. **Allocate more memory** to Docker Desktop:
   - Settings -> Resources -> Memory: 4GB+

## Production Considerations

⚠️ **This is a DEMO setup. For production:**

1. **Enable OpenSearch security**
   - Remove `DISABLE_SECURITY_PLUGIN=true`
   - Configure SSL/TLS
   - Set strong admin password

2. **Use multi-stage builds** (already done)

3. **Add health checks** (already done)

4. **Use environment variables** for secrets
   - Never commit passwords
   - Use Docker secrets or Azure Key Vault

5. **Configure proper CORS**
   - Restrict origins to production domains
   - Remove localhost from allowed origins

6. **Add monitoring**
   - Application Insights
   - Prometheus + Grafana
   - ELK stack

7. **Use orchestration**
   - Kubernetes (AKS)
   - Docker Swarm
   - Azure Container Apps

## Clean Up

### Remove everything:
```bash
docker-compose down -v
docker system prune -a
```

This removes:
- All containers
- All volumes (including seeded data)
- All images
- All networks
