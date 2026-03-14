#!/bin/bash

# OpenSearch Data Seeder Script
# Seeds sample risk aggregate data into OpenSearch

OPENSEARCH_URL="http://localhost:9200"
INDEX_NAME="risk-aggregates"

echo "Creating OpenSearch index: $INDEX_NAME"

# Create index with mappings
curl -XPUT "$OPENSEARCH_URL/$INDEX_NAME" -H 'Content-Type: application/json' -d'
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

echo -e "\n\nSeeding sample data..."

# Commodities
commodities=("Crude" "NaturalGas" "Gold" "Silver" "Copper" "Wheat" "Corn" "Power")
# Regions
regions=("NorthAmerica" "Europe" "Asia" "MiddleEast" "LatinAmerica")
# Counterparties
counterparties=("JP_Morgan" "Goldman_Sachs" "Morgan_Stanley" "Citigroup" "Bank_of_America")
# Portfolios
portfolios=("Energy_Trading" "Metals_Trading" "Agricultural_Trading" "Power_Trading")

# Generate 1000 sample records
for i in {1..1000}; do
  commodity=${commodities[$RANDOM % ${#commodities[@]}]}
  region=${regions[$RANDOM % ${#regions[@]}]}
  counterparty=${counterparties[$RANDOM % ${#counterparties[@]}]}
  portfolio=${portfolios[$RANDOM % ${#portfolios[@]}]}
  
  # Random P&L between -1,000,000 and 1,000,000
  pnl=$(echo "scale=2; ($RANDOM - 16384) * 30" | bc)
  
  # Random VaR between 10,000 and 500,000
  var=$(echo "scale=2; $RANDOM * 15 + 10000" | bc)
  
  # Random Exposure between 100,000 and 5,000,000
  exposure=$(echo "scale=2; $RANDOM * 150 + 100000" | bc)
  
  # Random date within last 365 days
  days_ago=$((RANDOM % 365))
  trade_date=$(date -d "$days_ago days ago" +%Y-%m-%d)
  
  curl -XPOST "$OPENSEARCH_URL/$INDEX_NAME/_doc" -H 'Content-Type: application/json' -d"
  {
    \"id\": \"RISK-$(printf '%06d' $i)\",
    \"commodity\": \"$commodity\",
    \"region\": \"$region\",
    \"profitAndLoss\": $pnl,
    \"vaR\": $var,
    \"exposure\": $exposure,
    \"tradeDate\": \"$trade_date\",
    \"counterparty\": \"$counterparty\",
    \"portfolio\": \"$portfolio\"
  }
  " > /dev/null 2>&1
  
  if [ $((i % 100)) -eq 0 ]; then
    echo "Seeded $i records..."
  fi
done

echo -e "\n\nData seeding complete! Seeded 1000 risk aggregate records."
echo "Refreshing index..."
curl -XPOST "$OPENSEARCH_URL/$INDEX_NAME/_refresh"

echo -e "\n\nVerifying data..."
curl -XGET "$OPENSEARCH_URL/$INDEX_NAME/_count"
echo -e "\n"
