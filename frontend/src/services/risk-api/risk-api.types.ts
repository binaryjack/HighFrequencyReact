import type { RiskAggregateResponse, RiskFilterRequest } from '../../types/risk-aggregate.types';

export type RiskApiClient = {
  fetchRiskAggregates: (filter: RiskFilterRequest) => Promise<RiskAggregateResponse>;
};
