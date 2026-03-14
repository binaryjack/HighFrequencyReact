#!/bin/sh

# Data Seeder Script for Docker
# Seeds sample risk aggregate data into OpenSearch

OPENSEARCH_URL="http://opensearch:9200"
INDEX_NAME="risk-aggregates"

echo "Waiting for OpenSearch to be ready..."
until curl -s "$OPENSEARCH_URL/_cluster/health" > /dev/null; do
  echo "OpenSearch not ready yet, waiting..."
  sleep 2
done

echo "OpenSearch is ready!"
echo "Creating index: $INDEX_NAME"

# Create index with mappings
curl -X PUT "$OPENSEARCH_URL/$INDEX_NAME" -H 'Content-Type: application/json' -d '{
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
}'

echo -e "\n\nSeeding sample data..."

# Arrays (using space-separated values for sh compatibility)
commodities="Crude NaturalGas Gold Silver Copper Wheat Corn Power"
regions="NorthAmerica Europe Asia MiddleEast LatinAmerica"
counterparties="JP_Morgan Goldman_Sachs Morgan_Stanley Citigroup Bank_of_America"
portfolios="Energy_Trading Metals_Trading Agricultural_Trading Power_Trading"

# Convert to arrays
set -- $commodities
commodity_array="$@"
set -- $regions
region_array="$@"
set -- $counterparties
counterparty_array="$@"
set -- $portfolios
portfolio_array="$@"

# Function to get random item from space-separated list
get_random_item() {
  items="$1"
  count=$(echo "$items" | wc -w)
  random_index=$((RANDOM % count + 1))
  echo "$items" | awk "{print \$$random_index}"
}

# Generate 1000 sample records
i=1
while [ $i -le 1000 ]; do
  commodity=$(get_random_item "$commodities")
  region=$(get_random_item "$regions")
  counterparty=$(get_random_item "$counterparties")
  portfolio=$(get_random_item "$portfolios")
  
  # Random P&L between -1,000,000 and 1,000,000
  pnl=$((RANDOM % 2000000 - 1000000))
  pnl_decimal=$(awk "BEGIN {printf \"%.2f\", $pnl + (RANDOM % 100) / 100}")
  
  # Random VaR between 10,000 and 500,000
  var=$((RANDOM % 490000 + 10000))
  var_decimal=$(awk "BEGIN {printf \"%.2f\", $var + (RANDOM % 100) / 100}")
  
  # Random Exposure between 100,000 and 5,000,000
  exposure=$((RANDOM % 4900000 + 100000))
  exposure_decimal=$(awk "BEGIN {printf \"%.2f\", $exposure + (RANDOM % 100) / 100}")
  
  # Random date within last 365 days
  days_ago=$((RANDOM % 365))
  trade_date=$(date -d "$days_ago days ago" +%Y-%m-%d 2>/dev/null || date -v-${days_ago}d +%Y-%m-%d)
  
  # Format ID with leading zeros
  id=$(printf "RISK-%06d" $i)
  
  # Create and send document
  curl -X POST "$OPENSEARCH_URL/$INDEX_NAME/_doc" -H 'Content-Type: application/json' -d "{
    \"id\": \"$id\",
    \"commodity\": \"$commodity\",
    \"region\": \"$region\",
    \"profitAndLoss\": $pnl_decimal,
    \"vaR\": $var_decimal,
    \"exposure\": $exposure_decimal,
    \"tradeDate\": \"$trade_date\",
    \"counterparty\": \"$counterparty\",
    \"portfolio\": \"$portfolio\"
  }" > /dev/null 2>&1
  
  if [ $((i % 100)) -eq 0 ]; then
    echo "Seeded $i records..."
  fi
  
  i=$((i + 1))
done

echo -e "\n\nData seeding complete! Seeded 1000 risk aggregate records."
echo "Refreshing index..."
curl -X POST "$OPENSEARCH_URL/$INDEX_NAME/_refresh"

echo -e "\n\nVerifying data..."
curl -X GET "$OPENSEARCH_URL/$INDEX_NAME/_count"
echo -e "\n\nSeeding completed successfully!"
