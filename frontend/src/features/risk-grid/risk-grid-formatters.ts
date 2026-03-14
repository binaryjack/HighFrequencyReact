import type { ValueFormatterParams } from 'ag-grid-enterprise'

export const formatCurrency = function (params: ValueFormatterParams): string {
  if (params.value == null) {
    return '';
  }
  
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(params.value);
};

export const formatNumber = function (params: ValueFormatterParams): string {
  if (params.value == null) {
    return '';
  }
  
  return new Intl.NumberFormat('en-US', {
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }).format(params.value);
};

export const formatDate = function (params: ValueFormatterParams): string {
  if (!params.value) {
    return '';
  }
  
  return new Date(params.value).toLocaleDateString('en-US');
};
