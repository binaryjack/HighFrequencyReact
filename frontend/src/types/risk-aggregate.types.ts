export interface RiskAggregate {
  id: string;
  commodity: string;
  region: string;
  profitAndLoss: number;
  vaR: number;
  exposure: number;
  tradeDate: string;
  counterparty: string;
  portfolio: string;
}

export interface RiskFilterRequest {
  commodity?: string;
  region?: string;
  startRow: number;
  endRow: number;
  sortModel?: SortModel[];
}

export interface SortModel {
  colId: string;
  sort: 'asc' | 'desc';
}

export interface RiskAggregateResponse {
  data: RiskAggregate[];
  totalCount: number;
  startRow: number;
  endRow: number;
}
