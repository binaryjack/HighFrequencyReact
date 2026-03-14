#!/bin/sh

OPENSEARCH_URL="http://opensearch:9200"
INDEX_NAME="risk-aggregates"

echo "Creating bulk payload..."

# Generate bulk JSON
{
  for i in $(seq 1 1000); do
    # Generate random values
    commodity=$(shuf -n1 -e "Crude" "NaturalGas" "Gold" "Silver" "Copper" "Wheat" "Corn" "Power")
    region=$(shuf -n1 -e "NorthAmerica" "Europe" "Asia" "MiddleEast" "LatinAmerica")
    counterparty=$(shuf -n1 -e "JPMorgan" "Goldman" "Morgan_Stanley" "Citigroup" "BofA")
    portfolio=$(shuf -n1 -e "Energy" "Metals" "Agricultural" "Power")
    
    pnl=$(awk -v seed="$RANDOM" 'BEGIN {srand(seed); printf "%.2f", (rand() * 2000000) - 1000000}')
   var=$(awk -v seed="$RANDOM" 'BEGIN {srand(seed); printf "%.2f", (rand() * 490000) + 10000}')
    exposure=$(awk -v seed="$RANDOM" 'BEGIN {srand(seed); printf "%.2f", (rand() * 4900000) + 100000}')
    days_ago=$((RANDOM % 365))
    trade_date=$(date -d "$days_ago days ago" +%Y-%m-%dT00:00:00Z 2>/dev/null || date -v-${days_ago}d +%Y-%m-%dT00:00:00Z)
    
    id=$(printf "RISK-%06d" $i)
    
    # Bulk format: { "index": {} }  then { document }
    echo "{\"index\":{}}"
    echo "{\"id\":\"$id\",\"commodity\":\"$commodity\",\"region\":\"$region\",\"profitAndLoss\":$pnl,\"vaR\":$var,\"exposure\":$exposure,\"tradeDate\":\"$trade_date\",\"counterparty\":\"$counterparty\",\"portfolio\":\"$portfolio\"}"
  done
} > /tmp/bulk.json

echo "Uploading $(wc -l < /tmp/bulk.json) lines to OpenSearch..."

curl -X POST "$OPENSEARCH_URL/$INDEX_NAME/_bulk" \
  -H 'Content-Type: application/x-ndjson' \
  --data-binary @/tmp/bulk.json

echo -e "\n\nRefreshing index..."
curl -X POST "$OPENSEARCH_URL/$INDEX_NAME/_refresh"

echo -e "\n\nVerifying count..."
curl -X GET "$OPENSEARCH_URL/$INDEX_NAME/_count"

echo -e "\n\nBulk seeding complete!"
