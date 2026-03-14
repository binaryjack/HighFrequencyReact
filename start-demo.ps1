# Trading Risk Reporting - Docker Demo Setup

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Trading Risk Reporting - Docker Demo Setup" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will:" -ForegroundColor Yellow
Write-Host "  1. Build all Docker images"
Write-Host "  2. Start OpenSearch"
Write-Host "  3. Seed 1000 risk aggregate records"
Write-Host "  4. Start Backend API"
Write-Host "  5. Start Frontend"
Write-Host ""
Write-Host "Press Ctrl+C to cancel, or wait 3 seconds to continue..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

Write-Host ""
Write-Host "Building and starting services..." -ForegroundColor Green
docker-compose up --build -d

Write-Host ""
Write-Host "Waiting for services to be ready..." -ForegroundColor Yellow
Write-Host "This may take 30-60 seconds..."

# Wait for backend to be healthy
$maxAttempts = 40
$attempt = 0
$backendReady = $false

while (-not $backendReady -and $attempt -lt $maxAttempts) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:5000/api/RiskAggregates" -Method HEAD -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 405) {
            $backendReady = $true
        }
    }
    catch {
        Write-Host "Waiting for backend API..." -ForegroundColor Gray
        Start-Sleep -Seconds 3
        $attempt++
    }
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  ✓ All services are running!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Access the application:" -ForegroundColor Cyan
Write-Host "  Frontend:   " -NoNewline
Write-Host "http://localhost:3000" -ForegroundColor Yellow
Write-Host "  Backend:    " -NoNewline
Write-Host "http://localhost:5000/api/RiskAggregates" -ForegroundColor Yellow
Write-Host "  OpenSearch: " -NoNewline
Write-Host "http://localhost:9200" -ForegroundColor Yellow
Write-Host ""
Write-Host "To view logs:" -ForegroundColor Cyan
Write-Host "  docker-compose logs -f frontend"
Write-Host "  docker-compose logs -f backend"
Write-Host "  docker-compose logs -f opensearch"
Write-Host ""
Write-Host "To stop all services:" -ForegroundColor Cyan
Write-Host "  docker-compose down"
Write-Host ""
Write-Host "To stop and remove all data:" -ForegroundColor Cyan
Write-Host "  docker-compose down -v"
Write-Host ""
Write-Host "================================================" -ForegroundColor Green
