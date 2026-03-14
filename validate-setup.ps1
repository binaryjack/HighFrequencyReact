# Validation script for Docker demo setup

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  Trading Risk Docker Demo - Validation" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

$allChecksPassed = $true

# Check requirements
Write-Host "Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

# Check Docker
Write-Host "Checking Docker..." -NoNewline
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  $dockerVersion" -ForegroundColor Gray
    } else {
        Write-Host " ✗" -ForegroundColor Red
        Write-Host "  Docker is not installed" -ForegroundColor Red
        Write-Host "  Install from: https://docs.docker.com/get-docker/" -ForegroundColor Yellow
        $allChecksPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    Write-Host "  Docker is not installed" -ForegroundColor Red
    $allChecksPassed = $false
}

# Check Docker Compose
Write-Host "Checking Docker Compose..." -NoNewline
try {
    $composeVersion = docker-compose --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✓" -ForegroundColor Green
        Write-Host "  $composeVersion" -ForegroundColor Gray
    } else {
        Write-Host " ✗" -ForegroundColor Red
        $allChecksPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    $allChecksPassed = $false
}

# Check if Docker is running
Write-Host "Checking Docker daemon..." -NoNewline
try {
    docker info 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host " ✓" -ForegroundColor Green
    } else {
        Write-Host " ✗" -ForegroundColor Red
        Write-Host "  Docker daemon is not running" -ForegroundColor Red
        Write-Host "  Please start Docker Desktop" -ForegroundColor Yellow
        $allChecksPassed = $false
    }
} catch {
    Write-Host " ✗" -ForegroundColor Red
    $allChecksPassed = $false
}

Write-Host ""
Write-Host "Checking port availability..." -ForegroundColor Yellow
Write-Host ""

# Check ports
function Test-Port {
    param($Port)
    
    $connections = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    
    if ($connections) {
        Write-Host "Port $Port" -NoNewline
        Write-Host " ⚠ In use" -ForegroundColor Yellow
        return $false
    } else {
        Write-Host "Port $Port" -NoNewline
        Write-Host " ✓ Available" -ForegroundColor Green
        return $true
    }
}

$portsOk = $true
$portsOk = (Test-Port 3000) -and $portsOk
$portsOk = (Test-Port 5000) -and $portsOk
$portsOk = (Test-Port 9200) -and $portsOk

if (-not $portsOk) {
    Write-Host ""
    Write-Host "Warning: Some ports are in use. The demo may fail to start." -ForegroundColor Yellow
    Write-Host "You can either:" -ForegroundColor Yellow
    Write-Host "  1. Stop services using these ports"
    Write-Host "  2. Modify ports in docker-compose.yml"
    Write-Host ""
}

Write-Host ""
Write-Host "Checking file structure..." -ForegroundColor Yellow
Write-Host ""

# Check key files exist
$files = @(
    "docker-compose.yml",
    "backend\Dockerfile",
    "backend\seed-data.sh",
    "frontend\Dockerfile",
    "frontend\nginx.conf"
)

$allFilesExist = $true
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "$file" -NoNewline
        Write-Host " ✓" -ForegroundColor Green
    } else {
        Write-Host "$file" -NoNewline
        Write-Host " ✗ Missing" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host ""
    Write-Host "Error: Some required files are missing" -ForegroundColor Red
    $allChecksPassed = $false
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan

if ($allChecksPassed) {
    Write-Host "✓ All prerequisites met!" -ForegroundColor Green
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "You can now run:" -ForegroundColor Yellow
    Write-Host "  .\start-demo.ps1"
    Write-Host ""
    Write-Host "Or manually:" -ForegroundColor Yellow
    Write-Host "  docker-compose up --build -d"
    Write-Host ""
} else {
    Write-Host "✗ Some checks failed" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please resolve the issues above before continuing." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
