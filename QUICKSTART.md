# Quick Start Guide

## Docker Quick Start (Recommended)

**One command** (Windows):
```powershell
.\start-demo.ps1
```

**One command** (Linux/Mac):
```bash
./start-demo.sh
```

Then open http://localhost:3000 - Done! ✨

---

## Manual Setup (Without Docker)

### 1. Start OpenSearch

Using Docker:
```bash
docker run -d -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" \
  -e "OPENSEARCH_INITIAL_ADMIN_PASSWORD=Admin123!" \
  opensearchproject/opensearch:latest
```

## 2. Seed Sample Data

### Windows (PowerShell):
```powershell
cd backend
.\seed-opensearch.ps1
```

### Linux/Mac:
```bash
cd backend
chmod +x seed-opensearch.sh
./seed-opensearch.sh
```

## 3. Start Backend

```bash
cd backend/src/TradingRisk.API
dotnet run
```

Backend will run on: http://localhost:5000

## 4. Start Frontend

```bash
cd frontend
pnpm install
pnpm dev
```

Frontend will run on: http://localhost:5173

## 5. Access Application

Open browser to: http://localhost:5173

You should see:
- A grid with 1000 risk aggregate records
- Filter dropdowns for Commodity and Region
- Sortable columns
- Server-side pagination

## Verify Setup

### Check OpenSearch:
```bash
curl http://localhost:9200/risk-aggregates/_count
```

Should return approximately 1000 documents.

### Check Backend API:
```bash
curl -X POST http://localhost:5000/api/RiskAggregates \
  -H "Content-Type: application/json" \
  -d '{"startRow":0,"endRow":10}'
```

Should return JSON with risk aggregate data.

## Troubleshooting

### OpenSearch not starting:
- Check port 9200 is available
- Verify Docker is running
- Check OpenSearch logs: `docker logs <container-id>`

### Backend errors:
- Verify OpenSearch is running
- Check appsettings.json for correct OpenSearch URL
- Ensure all NuGet packages are restored: `dotnet restore`

### Frontend not connecting:
- Check backend is running on port 5000
- Verify CORS is enabled in backend
- Check browser console for errors
- Ensure AG Grid Enterprise license is valid (or use Community)

## AG Grid Enterprise License

If you don't have an AG Grid Enterprise license:
1. You'll see a watermark and console warnings
2. For evaluation purposes, this is acceptable
3. For production, purchase a license from ag-grid.com

To add your license:
```typescript
// In frontend/src/index.tsx, add:
import { LicenseManager } from 'ag-grid-enterprise';
LicenseManager.setLicenseKey('YOUR_LICENSE_KEY');
```
