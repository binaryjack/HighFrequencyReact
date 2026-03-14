# Test script to verify Docker demo is working

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Testing Trading Risk Docker Demo" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$allTestsPassed = $true

# Test 1: Check containers are running
Write-Host "Test 1: Checking containers..." -NoNewline
try {
    $containers = (docker-compose ps -q 2>$null).Count
    if ($containers -ge 3) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  $containers containers running" -ForegroundColor Gray
    } else {
        Write-Host " ✗" -ForegroundColor Red
        Write-Host "  Expected at least 3 containers, found $containers" -ForegroundColor Red
        $allTestsPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    $allTestsPassed = $false
}

# Test 2: Check OpenSearch
Write-Host "Test 2: Testing OpenSearch..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9200" -Method Get -TimeoutSec 5 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  OpenSearch responding (HTTP $($response.StatusCode))" -ForegroundColor Gray
    } else {
        Write-Host " ✗" -ForegroundColor Red
        $allTestsPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "  OpenSearch not responding" -ForegroundColor Red
    $allTestsPassed = $false
}

# Test 3: Check data count
Write-Host "Test 3: Checking seeded data..." -NoNewline
try {
    $countResponse = Invoke-RestMethod -Uri "http://localhost:9200/risk-aggregates/_count" -Method Get -TimeoutSec 5
    $dataCount = $countResponse.count
    if ($dataCount -ge 900) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  Found $dataCount records in OpenSearch" -ForegroundColor Gray
    } else {
        Write-Host " ⚠" -ForegroundColor Yellow
        Write-Host "  Expected ~1000 records, found $dataCount" -ForegroundColor Yellow
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    $allTestsPassed = $false
}

# Test 4: Check Backend API
Write-Host "Test 4: Testing Backend API..." -NoNewline
try {
    $body = @{
        startRow = 0
        endRow = 10
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "http://localhost:5000/api/RiskAggregates" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body `
        -TimeoutSec 5 `
        -ErrorAction Stop

    if ($response.StatusCode -eq 200) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  Backend API responding (HTTP $($response.StatusCode))" -ForegroundColor Gray
    } else {
        Write-Host " ✗" -ForegroundColor Red
        $allTestsPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "  Backend API not responding: $($_.Exception.Message)" -ForegroundColor Red
    $allTestsPassed = $false
}

# Test 5: Check API returns data
Write-Host "Test 5: Validating API data..." -NoNewline
try {
    $body = @{
        startRow = 0
        endRow = 10
    } | ConvertTo-Json

    $apiData = Invoke-RestMethod -Uri "http://localhost:5000/api/RiskAggregates" `
        -Method Post `
        -ContentType "application/json" `
        -Body $body `
        -TimeoutSec 5

    if ($apiData.totalCount -gt 0) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  API returning data (totalCount: $($apiData.totalCount))" -ForegroundColor Gray
    } else {
        Write-Host " ✗" -ForegroundColor Red
        $allTestsPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    $allTestsPassed = $false
}

# Test 6: Check Frontend
Write-Host "Test 6: Testing Frontend..." -NoNewline
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000" -Method Get -TimeoutSec 5 -ErrorAction Stop
    if ($response.StatusCode -eq 200) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  Frontend responding (HTTP $($response.StatusCode))" -ForegroundColor Gray
    } else {
        Write-Host " ✗" -ForegroundColor Red
        $allTestsPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "  Frontend not responding" -ForegroundColor Red
    $allTestsPassed = $false
}

# Test 7: Check Frontend content
Write-Host "Test 7: Validating Frontend content..." -NoNewline
try {
    $frontendContent = Invoke-WebRequest -Uri "http://localhost:3000" -Method Get -TimeoutSec 5
    if ($frontendContent.Content -match "Trading Risk") {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  Frontend content looks correct" -ForegroundColor Gray
    } else {
        Write-Host " ⚠" -ForegroundColor Yellow
        Write-Host "  Frontend content may be incomplete" -ForegroundColor Yellow
    }
} catch {
    Write-Host " ⚠" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan

if ($allTestsPassed) {
    Write-Host "✓ All tests passed!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Your demo is ready:" -ForegroundColor Yellow
    Write-Host "  Frontend: " -NoNewline
    Write-Host "http://localhost:3000" -ForegroundColor Cyan
    Write-Host "  Backend:  " -NoNewline
    Write-Host "http://localhost:5000/api/RiskAggregates" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host "✗ Some tests failed" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  1. Check logs: docker-compose logs"
    Write-Host "  2. Restart: docker-compose restart"
    Write-Host "  3. See DOCKER.md for detailed troubleshooting"
    Write-Host ""
    exit 1
}
