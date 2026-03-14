#!/bin/bash

echo "================================================"
echo "  Trading Risk Reporting - Docker Demo Setup"
echo "================================================"
echo ""
echo "This will:"
echo "  1. Build all Docker images"
echo "  2. Start OpenSearch"
echo "  3. Seed 1000 risk aggregate records"
echo "  4. Start Backend API"
echo "  5. Start Frontend"
echo ""
echo "Press Ctrl+C to cancel, or wait 3 seconds to continue..."
sleep 3

echo ""
echo "Building and starting services..."
docker-compose up --build -d

echo ""
echo "Waiting for services to be ready..."
echo "This may take 30-60 seconds..."

# Wait for backend to be healthy
until curl -s http://localhost:5000/api/RiskAggregates > /dev/null 2>&1; do
  echo "Waiting for backend API..."
  sleep 3
done

echo ""
echo "================================================"
echo "  ✓ All services are running!"
echo "================================================"
echo ""
echo "Access the application:"
echo "  Frontend:   http://localhost:3000"
echo "  Backend:    http://localhost:5000/api/RiskAggregates"
echo "  OpenSearch: http://localhost:9200"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f frontend"
echo "  docker-compose logs -f backend"
echo "  docker-compose logs -f opensearch"
echo ""
echo "To stop all services:"
echo "  docker-compose down"
echo ""
echo "To stop and remove all data:"
echo "  docker-compose down -v"
echo ""
echo "================================================"
