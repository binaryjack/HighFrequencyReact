import type { GridOptions, IServerSideDatasource } from 'ag-grid-enterprise';

export interface RiskGridProps {
  commodity?: string;
  region?: string;
}

export type RiskGridConfig = {
  gridOptions: GridOptions;
  datasource: IServerSideDatasource;
};
