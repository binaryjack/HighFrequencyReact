#!/bin/bash

# Test script to verify Docker demo is working

echo "================================================"
echo "  Testing Trading Risk Docker Demo"
echo "================================================"
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

all_tests_passed=true

# Test 1: Check containers are running
echo "Test 1: Checking containers..."
containers=$(docker-compose ps -q 2>/dev/null | wc -l)
if [ "$containers" -ge 3 ]; then
    echo -e "${GREEN}✓${NC} $containers containers running"
else
    echo -e "${RED}✗${NC} Expected at least 3 containers, found $containers"
    all_tests_passed=false
fi

# Test 2: Check OpenSearch
echo "Test 2: Testing OpenSearch..."
opensearch_response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9200)
if [ "$opensearch_response" -eq 200 ]; then
    echo -e "${GREEN}✓${NC} OpenSearch responding (HTTP $opensearch_response)"
else
    echo -e "${RED}✗${NC} OpenSearch not responding (HTTP $opensearch_response)"
    all_tests_passed=false
fi

# Test 3: Check data count
echo "Test 3: Checking seeded data..."
data_count=$(curl -s http://localhost:9200/risk-aggregates/_count | grep -o '"count":[0-9]*' | grep -o '[0-9]*')
if [ "$data_count" -ge 900 ]; then
    echo -e "${GREEN}✓${NC} Found $data_count records in OpenSearch"
else
    echo -e "${YELLOW}⚠${NC} Expected ~1000 records, found $data_count"
fi

# Test 4: Check Backend API
echo "Test 4: Testing Backend API..."
backend_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:5000/api/RiskAggregates \
  -H "Content-Type: application/json" \
  -d '{"startRow":0,"endRow":10}')
if [ "$backend_response" -eq 200 ]; then
    echo -e "${GREEN}✓${NC} Backend API responding (HTTP $backend_response)"
else
    echo -e "${RED}✗${NC} Backend API not responding (HTTP $backend_response)"
    all_tests_passed=false
fi

# Test 5: Check API returns data
echo "Test 5: Validating API data..."
api_data=$(curl -s -X POST http://localhost:5000/api/RiskAggregates \
  -H "Content-Type: application/json" \
  -d '{"startRow":0,"endRow":10}')
if echo "$api_data" | grep -q '"totalCount"'; then
    record_count=$(echo "$api_data" | grep -o '"totalCount":[0-9]*' | grep -o '[0-9]*')
    echo -e "${GREEN}✓${NC} API returning data (totalCount: $record_count)"
else
    echo -e "${RED}✗${NC} API not returning expected data"
    all_tests_passed=false
fi

# Test 6: Check Frontend
echo "Test 6: Testing Frontend..."
frontend_response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$frontend_response" -eq 200 ]; then
    echo -e "${GREEN}✓${NC} Frontend responding (HTTP $frontend_response)"
else
    echo -e "${RED}✗${NC} Frontend not responding (HTTP $frontend_response)"
    all_tests_passed=false
fi

# Test 7: Check Frontend content
echo "Test 7: Validating Frontend content..."
frontend_content=$(curl -s http://localhost:3000)
if echo "$frontend_content" | grep -q "Trading Risk"; then
    echo -e "${GREEN}✓${NC} Frontend content looks correct"
else
    echo -e "${YELLOW}⚠${NC} Frontend content may be incomplete"
fi

echo ""
echo "================================================"
if [ "$all_tests_passed" = true ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo "================================================"
    echo ""
    echo "Your demo is ready:"
    echo "  Frontend: http://localhost:3000"
    echo "  Backend:  http://localhost:5000/api/RiskAggregates"
    echo ""
else
    echo -e "${RED}✗ Some tests failed${NC}"
    echo "================================================"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check logs: docker-compose logs"
    echo "  2. Restart: docker-compose restart"
    echo "  3. See DOCKER.md for detailed troubleshooting"
    echo ""
    exit 1
fi
