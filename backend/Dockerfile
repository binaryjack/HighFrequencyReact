# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files
COPY src/TradingRisk.Domain/TradingRisk.Domain.csproj TradingRisk.Domain/
COPY src/TradingRisk.Application/TradingRisk.Application.csproj TradingRisk.Application/
COPY src/TradingRisk.Infrastructure/TradingRisk.Infrastructure.csproj TradingRisk.Infrastructure/
COPY src/TradingRisk.API/TradingRisk.API.csproj TradingRisk.API/

# Restore dependencies
RUN dotnet restore TradingRisk.API/TradingRisk.API.csproj

# Copy source code
COPY src/ .

# Build
RUN dotnet build TradingRisk.API/TradingRisk.API.csproj -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish TradingRisk.API/TradingRisk.API.csproj -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Expose ports
EXPOSE 80
EXPOSE 443

ENTRYPOINT ["dotnet", "TradingRisk.API.dll"]
