import type { ColDef, GridOptions } from 'ag-grid-community'
import { formatCurrency, formatDate, formatNumber } from './risk-grid-formatters'

export const createColumnDefs = function (): ColDef[] {
  return [
    { field: 'id', headerName: 'ID', width: 100, sortable: true, filter: true },
    { field: 'commodity', headerName: 'Commodity', width: 130, sortable: true, filter: true },
    { field: 'region', headerName: 'Region', width: 150, sortable: true, filter: true },
    { 
      field: 'profitAndLoss', 
      headerName: 'P&L', 
      width: 150, 
      sortable: true, 
      filter: 'agNumberColumnFilter',
      valueFormatter: formatCurrency,
      type: 'numericColumn'
    },
    { 
      field: 'vaR', 
      headerName: 'VaR', 
      width: 130, 
      sortable: true, 
      filter: 'agNumberColumnFilter',
      valueFormatter: formatCurrency,
      type: 'numericColumn'
    },
    { 
      field: 'exposure', 
      headerName: 'Exposure', 
      width: 150, 
      sortable: true, 
      filter: 'agNumberColumnFilter',
      valueFormatter: formatNumber,
      type: 'numericColumn'
    },
    { 
      field: 'tradeDate', 
      headerName: 'Trade Date', 
      width: 130, 
      sortable: true, 
      filter: 'agDateColumnFilter',
      valueFormatter: formatDate
    },
    { field: 'counterparty', headerName: 'Counterparty', width: 150, sortable: true, filter: true },
    { field: 'portfolio', headerName: 'Portfolio', width: 130, sortable: true, filter: true },
  ];
};

export const createGridOptions = function (): GridOptions {
  return {
    columnDefs: createColumnDefs(),
    defaultColDef: {
      resizable: true,
      sortable: true,
      filter: true,
    },
    pagination: true,
    paginationPageSize: 100,
    animateRows: true,
    enableCellTextSelection: true,
  };
};
