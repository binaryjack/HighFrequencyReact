# OpenSearch Data Seeder Script (PowerShell)
# Seeds sample risk aggregate data into OpenSearch

$OPENSEARCH_URL = "http://localhost:9200"
$INDEX_NAME = "risk-aggregates"

Write-Host "Creating OpenSearch index: $INDEX_NAME"

# Create index with mappings
$mappings = @{
    mappings = @{
        properties = @{
            id = @{ type = "keyword" }
            commodity = @{ type = "keyword" }
            region = @{ type = "keyword" }
            profitAndLoss = @{ type = "double" }
            vaR = @{ type = "double" }
            exposure = @{ type = "double" }
            tradeDate = @{ type = "date" }
            counterparty = @{ type = "keyword" }
            portfolio = @{ type = "keyword" }
        }
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Uri "$OPENSEARCH_URL/$INDEX_NAME" -Method Put -Body $mappings -ContentType "application/json"

Write-Host "`nSeeding sample data..."

# Arrays
$commodities = @("Crude", "NaturalGas", "Gold", "Silver", "Copper", "Wheat", "Corn", "Power")
$regions = @("NorthAmerica", "Europe", "Asia", "MiddleEast", "LatinAmerica")
$counterparties = @("JP_Morgan", "Goldman_Sachs", "Morgan_Stanley", "Citigroup", "Bank_of_America")
$portfolios = @("Energy_Trading", "Metals_Trading", "Agricultural_Trading", "Power_Trading")

# Generate 1000 sample records
for ($i = 1; $i -le 1000; $i++) {
    $commodity = $commodities | Get-Random
    $region = $regions | Get-Random
    $counterparty = $counterparties | Get-Random
    $portfolio = $portfolios | Get-Random
    
    # Random P&L between -1,000,000 and 1,000,000
    $pnl = [math]::Round((Get-Random -Minimum -1000000 -Maximum 1000000), 2)
    
    # Random VaR between 10,000 and 500,000
    $var = [math]::Round((Get-Random -Minimum 10000 -Maximum 500000), 2)
    
    # Random Exposure between 100,000 and 5,000,000
    $exposure = [math]::Round((Get-Random -Minimum 100000 -Maximum 5000000), 2)
    
    # Random date within last 365 days
    $daysAgo = Get-Random -Minimum 0 -Maximum 365
    $tradeDate = (Get-Date).AddDays(-$daysAgo).ToString("yyyy-MM-dd")
    
    $document = @{
        id = "RISK-{0:D6}" -f $i
        commodity = $commodity
        region = $region
        profitAndLoss = $pnl
        vaR = $var
        exposure = $exposure
        tradeDate = $tradeDate
        counterparty = $counterparty
        portfolio = $portfolio
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri "$OPENSEARCH_URL/$INDEX_NAME/_doc" -Method Post -Body $document -ContentType "application/json" | Out-Null
    
    if ($i % 100 -eq 0) {
        Write-Host "Seeded $i records..."
    }
}

Write-Host "`nData seeding complete! Seeded 1000 risk aggregate records."
Write-Host "Refreshing index..."
Invoke-RestMethod -Uri "$OPENSEARCH_URL/$INDEX_NAME/_refresh" -Method Post

Write-Host "`nVerifying data..."
$count = Invoke-RestMethod -Uri "$OPENSEARCH_URL/$INDEX_NAME/_count" -Method Get
Write-Host "Total documents: $($count.count)"
