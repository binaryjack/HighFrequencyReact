import 'ag-grid-community/styles/ag-grid.css'
import 'ag-grid-community/styles/ag-theme-alpine.css'
import { AgGridReact } from 'ag-grid-react'
import React, { useEffect, useMemo, useState } from 'react'
import { createRiskApiClient } from '../../services/risk-api'
import type { RiskAggregate, RiskFilterRequest } from '../../types/risk-aggregate.types'
import { createGridOptions } from './create-risk-grid-config'
import type { RiskGridProps } from './risk-grid.types'

export const RiskGrid = function (props: RiskGridProps): React.ReactElement {
  const [rowData, setRowData] = useState<RiskAggregate[]>([]);
  const [loading, setLoading] = useState(true);
  const apiClient = useMemo(() => createRiskApiClient(), []);

  useEffect(() => {
    const loadData = async function (): Promise<void> {
      try {
        setLoading(true);
        const filter: RiskFilterRequest = {
          commodity: props.commodity,
          region: props.region,
          startRow: 0,
          endRow: 10000, // Load all data
        };

        const response = await apiClient.fetchRiskAggregates(filter);
        setRowData(response.data);
      } catch (error) {
        console.error('Error fetching risk aggregates:', error);
        setRowData([]);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, [apiClient, props.commodity, props.region]);

  const gridOptions = useMemo(() => createGridOptions(), []);

  return (
    <div className="ag-theme-alpine" style={{ height: '600px', width: '100%' }}>
      {loading && <div style={{ padding: '10px' }}>Loading...</div>}
      <AgGridReact
        rowData={rowData}
        {...gridOptions}
      />
    </div>
  );
};
