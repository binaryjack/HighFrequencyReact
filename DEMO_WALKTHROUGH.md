# 🎯 Complete Demo Walkthrough

## Overview

This is a complete, production-ready boilerplate for a **Trading Risk Reporting** application demonstrating:
- Clean Architecture (.NET 8)
- OpenSearch integration with NEST client
- React 18 with AG Grid Enterprise Server-Side Row Model
- Full Docker containerization with automatic data seeding

## 📋 Prerequisites

Before you begin, ensure you have:
- ✅ Docker Desktop installed and running
- ✅ 4GB+ RAM allocated to Docker
- ✅ Ports 3000, 5000, 9200 available

## 🚀 Step-by-Step Demo

### Step 1: Validate Your Setup

**Windows:**
```powershell
.\validate-setup.ps1
```

**Linux/Mac:**
```bash
chmod +x validate-setup.sh
./validate-setup.sh
```

This checks:
- Docker is installed and running
- Required ports are available
- All necessary files exist

### Step 2: Start the Demo

**Windows:**
```powershell
.\start-demo.ps1
```

**Linux/Mac:**
```bash
chmod +x start-demo.sh
./start-demo.sh
```

This will:
1. Build Docker images (first time: ~5-10 minutes)
2. Start OpenSearch database
3. Seed 1000 sample risk aggregate records
4. Start Backend API (.NET 8)
5. Start Frontend (React 18)

Wait for: **"✓ All services are running!"**

### Step 3: Test the Demo

**Windows:**
```powershell
.\test-demo.ps1
```

**Linux/Mac:**
```bash
chmod +x test-demo.sh
./test-demo.sh
```

This verifies:
- All containers are running
- OpenSearch is healthy
- Data is seeded (1000 records)
- Backend API is responding
- Frontend is serving pages

### Step 4: Explore the Application

#### Access the Frontend
Open your browser to: **http://localhost:3000**

You'll see:
- **Trading Risk Reporting** dashboard
- Filter dropdowns for Commodity and Region
- AG Grid with Server-Side Row Model
- 1000 pre-loaded risk aggregate records

#### Try These Features:

**1. Sorting**
- Click any column header to sort
- Multi-column sort: Shift+Click
- Server-side sorting via OpenSearch

**2. Filtering**
- Use dropdown filters:
  - Commodity: Crude, NaturalGas, Gold, Silver, etc.
  - Region: NorthAmerica, Europe, Asia, etc.
- Grid updates automatically via API call

**3. Pagination**
- Scroll through data
- Server-side pagination (100 rows per page)
- Total count displayed at bottom

**4. Column Features**
- P&L column: Currency formatting ($)
- VaR column: Risk metrics
- Date column: Formatted trade dates
- Resize columns by dragging headers

### Step 5: Test the Backend API

**Using curl (Windows PowerShell):**
```powershell
$body = @{
    commodity = "Gold"
    region = "Asia"
    startRow = 0
    endRow = 10
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:5000/api/RiskAggregates" `
    -Method Post `
    -ContentType "application/json" `
    -Body $body
```

**Using curl (Linux/Mac/Git Bash):**
```bash
curl -X POST http://localhost:5000/api/RiskAggregates \
  -H "Content-Type: application/json" \
  -d '{
    "commodity": "Gold",
    "region": "Asia",
    "startRow": 0,
    "endRow": 10
  }'
```

**Expected Response:**
```json
{
  "data": [
    {
      "id": "RISK-000123",
      "commodity": "Gold",
      "region": "Asia",
      "profitAndLoss": 125000.50,
      "vaR": 45000.00,
      "exposure": 2500000.00,
      "tradeDate": "2026-03-10T00:00:00",
      "counterparty": "JP_Morgan",
      "portfolio": "Metals_Trading"
    }
  ],
  "totalCount": 1000,
  "startRow": 0,
  "endRow": 10
}
```

### Step 6: Query OpenSearch Directly

**Check index health:**
```bash
curl http://localhost:9200/risk-aggregates/_count
```

**Sample query:**
```bash
curl -X POST http://localhost:9200/risk-aggregates/_search \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          { "term": { "commodity": "Crude" } },
          { "term": { "region": "NorthAmerica" } }
        ]
      }
    },
    "size": 5
  }'
```

### Step 7: View Logs (Optional)

**All services:**
```bash
docker-compose logs -f
```

**Specific service:**
```bash
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f opensearch
```

**Seeder logs (data seeding):**
```bash
docker-compose logs seeder
```

### Step 8: Architecture Verification

#### Backend Clean Architecture

Navigate through the code:

**Domain Layer:**
- `backend/src/TradingRisk.Domain/Entities/RiskAggregate.cs`
- Pure POCOs, no dependencies

**Application Layer:**
- `backend/src/TradingRisk.Application/Services/RiskAggregateService.cs`
- Business logic

**Infrastructure Layer:**
- `backend/src/TradingRisk.Infrastructure/OpenSearch/Repositories/RiskAggregateRepository.cs`
- OpenSearch queries with boolean filters

**API Layer:**
- `backend/src/TradingRisk.API/Controllers/RiskAggregatesController.cs`
- RESTful endpoint with async/await

#### Frontend Architecture

Navigate through the code:

**Types (*.types.ts):**
- `frontend/src/types/risk-aggregate.types.ts`
- `frontend/src/features/risk-grid/risk-grid.types.ts`

**Factory Functions (create-*.ts):**
- `frontend/src/features/risk-grid/create-risk-grid-config.ts`
- AG Grid configuration with useMemo

**Components (*.tsx):**
- `frontend/src/features/risk-grid/risk-grid.tsx`
- Functional component, no classes
- Server-Side Row Model (SSRM)

**Formatters:**
- `frontend/src/features/risk-grid/risk-grid-formatters.ts`
- Currency formatting for P&L

### Step 9: Make Changes (Development Mode)

Want to modify code with hot reload?

```bash
docker-compose -f docker-compose.dev.yml up --build
```

Now edit:
- **Backend**: Changes in `backend/src/` auto-reload
- **Frontend**: Changes in `frontend/src/` auto-reload (HMR)

### Step 10: Stop the Demo

**Keep data (can restart later):**
```bash
docker-compose down
```

**Remove everything (including data):**
```bash
docker-compose down -v
```

## 🎨 What to Show in Your Demo

### 1. Architecture Compliance
- **Backend**: Clean Architecture with 4 distinct layers
- **Frontend**: Follows copilot-instructions.md rules:
  - ✅ No classes
  - ✅ No `any` types
  - ✅ Kebab-case naming
  - ✅ Function expressions only
  - ✅ One item per file

### 2. Technology Stack
- **.NET 8** Web API with async/await
- **OpenSearch** with NEST client
- **React 18** with TypeScript (strict mode)
- **AG Grid Enterprise** with SSRM
- **Docker** with multi-stage builds

### 3. Key Features
- **Boolean Query Filtering** in OpenSearch
- **Server-Side Row Model** for large datasets
- **Currency Formatters** with useMemo optimization
- **Dependency Injection** throughout backend
- **Clean separation** of concerns

### 4. Production-Ready Elements
- Health checks on all containers
- Multi-stage Docker builds (optimized images)
- Environment-based configuration
- CORS properly configured
- Error handling in API
- TypeScript strict mode

## 📊 Demo Talking Points

### For Technical Audience:

**Backend:**
- "Clean Architecture with strict layer separation"
- "OpenSearch integration using NEST client with boolean queries"
- "Dependency injection for OpenSearch client configuration"
- "Async/await patterns throughout the API"

**Frontend:**
- "AG Grid Enterprise SSRM for handling large datasets"
- "useMemo optimization for grid configuration"
- "No classes - pure functional React"
- "TypeScript strict mode with zero 'any' types"

**Infrastructure:**
- "Complete Docker containerization"
- "Automatic data seeding on first run"
- "Multi-stage builds for minimal image sizes"
- "Health checks ensure proper startup order"

### For Business Audience:

- "One-command demo setup - fully containerized"
- "Handles 1000+ records with smooth pagination"
- "Real-time filtering by commodity and region"
- "Professional currency formatting for P&L display"
- "Production-ready architecture and deployment"

## 🐛 Troubleshooting

### Demo won't start?
```bash
# Check Docker is running
docker info

# Check ports
netstat -ano | findstr ":3000 :5000 :9200"  # Windows
lsof -i:3000 -i:5000 -i:9200                # Mac/Linux

# View detailed errors
docker-compose logs
```

### Data not showing?
```bash
# Verify seeding completed
docker-compose logs seeder

# Check record count
curl http://localhost:9200/risk-aggregates/_count

# Re-seed if needed
docker-compose up seeder
```

### Frontend shows connection error?
```bash
# Verify backend is running
curl -X POST http://localhost:5000/api/RiskAggregates \
  -H "Content-Type: application/json" \
  -d '{"startRow":0,"endRow":10}'

# Check browser console for CORS errors
# Check docker-compose logs backend
```

## 📚 Documentation Reference

- **[README.md](README.md)** - Main project overview
- **[DOCKER.md](DOCKER.md)** - Comprehensive Docker guide
- **[DOCKER_SUMMARY.md](DOCKER_SUMMARY.md)** - Complete Docker overview
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Architecture compliance
- **[QUICKSTART.md](QUICKSTART.md)** - Manual setup guide

## ✅ Success Criteria

Your demo is successful when:
- ✅ All containers running: `docker-compose ps`
- ✅ Frontend accessible: http://localhost:3000
- ✅ Backend API responding: http://localhost:5000/api/RiskAggregates
- ✅ Data visible in grid (1000 records)
- ✅ Filtering works (try Commodity: "Gold")
- ✅ Sorting works (click P&L column)
- ✅ Currency formatting displays correctly

## 🎓 Learning Points

This boilerplate demonstrates:
1. **Clean Architecture** separation of concerns
2. **OpenSearch** boolean query filters
3. **AG Grid SSRM** for enterprise data grids
4. **React patterns** without classes
5. **TypeScript strict mode** best practices
6. **Docker containerization** for demos
7. **Automated data seeding** for demonstrations

## 🚀 Next Steps

After the demo:
1. Explore the code structure
2. Modify filters to add more fields
3. Add new columns to the grid
4. Implement additional OpenSearch queries
5. Deploy to cloud (Azure, AWS, etc.)

---

**Demo Ready!** 🎉 Everything automated, one command to run!
