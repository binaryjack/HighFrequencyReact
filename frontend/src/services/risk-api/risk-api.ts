import type { RiskAggregateResponse, RiskFilterRequest } from '../../types/risk-aggregate.types'
import type { RiskApiClient } from './risk-api.types'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api';

export const createRiskApiClient = function (): RiskApiClient {
  const fetchRiskAggregates = async function (filter: RiskFilterRequest): Promise<RiskAggregateResponse> {
    const response = await fetch(`${BASE_URL}/RiskAggregates`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(filter),
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    return await response.json();
  };

  return {
    fetchRiskAggregates,
  };
};
