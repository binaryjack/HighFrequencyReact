# Trading Risk Reporting

Full-stack application for trading risk aggregation and reporting using .NET 8 Web API backend with OpenSearch and React 18 frontend with AG Grid Enterprise.

## 🚀 Quick Start with Docker

**Validate setup first:**
```powershell
# Windows
.\validate-setup.ps1

# Linux/Mac
./validate-setup.sh
```

**One-command demo** (Windows):
```powershell
.\start-demo.ps1
```

**One-command demo** (Linux/Mac):
```bash
chmod +x start-demo.sh && ./start-demo.sh
```

Then open http://localhost:3000 ✨

**What you get:**
- ✅ OpenSearch running with 1000 seeded records
- ✅ .NET 8 Backend API
- ✅ React 18 Frontend with AG Grid
- ✅ All connected and ready to demo

See [DOCKER.md](DOCKER.md) for detailed instructions or [DOCKER_SUMMARY.md](DOCKER_SUMMARY.md) for complete overview.

## Architecture

### Backend (.NET 8)
- **Clean Architecture**: Domain, Application, Infrastructure, API layers
- **OpenSearch Integration**: NEST client for high-performance data retrieval
- **Dependency Injection**: Service layer pattern

### Frontend (React 18)
- **AG Grid Enterprise**: Server-Side Row Model (SSRM) for large datasets
- **TypeScript**: Strict typing with no 'any' usage
- **Functional Components**: Declarative React patterns only

## Project Structure

```
trading-risk-reporting/
├── backend/                  # .NET 8 Web API
│   └── src/
│       ├── TradingRisk.Domain/
│       ├── TradingRisk.Application/
│       ├── TradingRisk.Infrastructure/
│       └── TradingRisk.API/
└── frontend/                 # React 18 + TypeScript
    └── src/
        ├── features/
        ├── services/
        └── types/
```

## Prerequisites

### Backend
- .NET 8 SDK
- OpenSearch 2.x or higher

### Frontend
- Node.js 18+
- pnpm (or npm/yarn)

## Setup Instructions

### Option 1: Docker (Recommended for Demo)

See [DOCKER.md](DOCKER.md) or use the quick start above.

### Option 2: Manual Setup

#### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Restore dependencies:
```bash
dotnet restore
```

3. Update `appsettings.json` with your OpenSearch connection:
```json
{
  "OpenSearch": {
    "Uri": "http://localhost:9200",
    "DefaultIndex": "risk-aggregates",
    "Username": "",
    "Password": ""
  }
}
```

4. Run the API:
```bash
cd src/TradingRisk.API
dotnet run
```

The API will be available at `http://localhost:5000`

### Frontend Setup

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
pnpm install
```

3. Set AG Grid Enterprise license (if you have one):
Create a `.env` file with:
```
VITE_AG_GRID_LICENSE=your-license-key
```

4. Start development server:
```bash
pnpm dev
```

The app will be available at `http://localhost:5173`

## API Endpoints

### POST /api/RiskAggregates
Retrieve risk aggregates with filtering and pagination.

**Request Body:**
```json
{
  "commodity": "Crude",
  "region": "NorthAmerica",
  "startRow": 0,
  "endRow": 100,
  "sortModel": [
    {
      "colId": "profitAndLoss",
      "sort": "desc"
    }
  ]
}
```

**Response:**
```json
{
  "data": [...],
  "totalCount": 1000,
  "startRow": 0,
  "endRow": 100
}
```

## OpenSearch Index Setup

Create the risk-aggregates index:

```bash
curl -XPUT "localhost:9200/risk-aggregates" -H 'Content-Type: application/json' -d'
{
  "mappings": {
    "properties": {
      "id": { "type": "keyword" },
      "commodity": { "type": "keyword" },
      "region": { "type": "keyword" },
      "profitAndLoss": { "type": "double" },
      "vaR": { "type": "double" },
      "exposure": { "type": "double" },
      "tradeDate": { "type": "date" },
      "counterparty": { "type": "keyword" },
      "portfolio": { "type": "keyword" }
    }
  }
}
'
```

## Key Features

- **Server-Side Row Model**: AG Grid fetches data on-demand for optimal performance
- **Boolean Query Filtering**: OpenSearch filters by commodity and region
- **Currency Formatting**: P&L displayed with proper currency symbols
- **Sorting & Pagination**: Full support via AG Grid and OpenSearch
- **Async/Await**: All API operations use async patterns
- **Clean Code**: Follows architectural patterns and conventions

## Development

### Backend Tests
```bash
cd backend
dotnet test
```

### Frontend Linting
```bash
cd frontend
pnpm lint
```

### Frontend Type Checking
```bash
cd frontend
pnpm build
```

## Architecture Principles

### Backend
- Domain entities are pure POCOs
- Application layer handles business logic
- Infrastructure layer contains external dependencies (OpenSearch)
- API layer exposes RESTful endpoints

### Frontend
- Kebab-case file naming
- One component/service per file
- Function expressions over arrow functions for exports
- No classes (functional programming)
- Strict TypeScript (no 'any' types)
- Types in *.types.ts files
- Feature-based folder structure

## License

MIT
