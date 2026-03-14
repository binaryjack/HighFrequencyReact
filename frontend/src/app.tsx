import React, { useState } from 'react';
import { RiskGrid } from './features/risk-grid';

export const App = function (): React.ReactElement {
  const [commodity, setCommodity] = useState<string | undefined>(undefined);
  const [region, setRegion] = useState<string | undefined>(undefined);

  return (
    <div style={{ padding: '20px' }}>
      <h1>Trading Risk Reporting</h1>
      
      <div style={{ marginBottom: '20px', display: 'flex', gap: '10px' }}>
        <div>
          <label htmlFor="commodity">Commodity: </label>
          <select 
            id="commodity"
            value={commodity || ''} 
            onChange={(e) => setCommodity(e.target.value || undefined)}
          >
            <option value="">All</option>
            <option value="Crude">Crude</option>
            <option value="NaturalGas">Natural Gas</option>
            <option value="Gold">Gold</option>
            <option value="Silver">Silver</option>
            <option value="Copper">Copper</option>
            <option value="Wheat">Wheat</option>
            <option value="Corn">Corn</option>
            <option value="Power">Power</option>
          </select>
        </div>
        
        <div>
          <label htmlFor="region">Region: </label>
          <select 
            id="region"
            value={region || ''} 
            onChange={(e) => setRegion(e.target.value || undefined)}
          >
            <option value="">All</option>
            <option value="NorthAmerica">North America</option>
            <option value="Europe">Europe</option>
            <option value="Asia">Asia</option>
            <option value="MiddleEast">Middle East</option>
            <option value="LatinAmerica">Latin America</option>
          </select>
        </div>
      </div>

      <RiskGrid commodity={commodity} region={region} />
    </div>
  );
};
