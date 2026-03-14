# Trading Risk Reporting - Project Structure

```
trading-risk-reporting/
├── backend/                                    # .NET 8 Web API
│   ├── src/
│   │   ├── TradingRisk.Domain/                # Domain Layer
│   │   │   ├── Entities/
│   │   │   │   └── RiskAggregate.cs
│   │   │   ├── Enums/
│   │   │   │   ├── Commodity.cs
│   │   │   │   └── Region.cs
│   │   │   └── TradingRisk.Domain.csproj
│   │   │
│   │   ├── TradingRisk.Application/           # Application Layer
│   │   │   ├── Interfaces/
│   │   │   │   └── IRiskAggregateService.cs
│   │   │   ├── DTOs/
│   │   │   │   ├── RiskAggregateDto.cs
│   │   │   │   └── RiskFilterDto.cs
│   │   │   ├── Services/
│   │   │   │   └── RiskAggregateService.cs
│   │   │   └── TradingRisk.Application.csproj
│   │   │
│   │   ├── TradingRisk.Infrastructure/        # Infrastructure Layer
│   │   │   ├── OpenSearch/
│   │   │   │   ├── Configuration/
│   │   │   │   │   └── OpenSearchSettings.cs
│   │   │   │   ├── Repositories/
│   │   │   │   │   └── RiskAggregateRepository.cs
│   │   │   │   └── Extensions/
│   │   │   │       └── OpenSearchExtensions.cs
│   │   │   └── TradingRisk.Infrastructure.csproj
│   │   │
│   │   └── TradingRisk.API/                   # API Layer
│   │       ├── Controllers/
│   │       │   └── RiskAggregatesController.cs
│   │       ├── Program.cs
│   │       ├── appsettings.json
│   │       └── TradingRisk.API.csproj
│   │
│   └── TradingRisk.sln
│
└── frontend/                                   # React 18 + TypeScript
    ├── src/
    │   ├── features/
    │   │   └── risk-grid/
    │   │       ├── risk-grid.types.ts
    │   │       ├── risk-grid.tsx
    │   │       ├── create-risk-grid-config.ts
    │   │       ├── risk-grid-formatters.ts
    │   │       └── index.ts
    │   │
    │   ├── services/
    │   │   └── risk-api/
    │   │       ├── risk-api.types.ts
    │   │       ├── risk-api.ts
    │   │       └── index.ts
    │   │
    │   ├── types/
    │   │   └── risk-aggregate.types.ts
    │   │
    │   ├── app.tsx
    │   └── index.tsx
    │
    ├── package.json
    ├── tsconfig.json
    └── vite.config.ts
```
