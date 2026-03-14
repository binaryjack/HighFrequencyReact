using TradingRisk.Application.DTOs;

namespace TradingRisk.Application.Interfaces;

public interface IRiskAggregateService
{
    Task<(List<RiskAggregateDto> Data, long TotalCount)> GetRiskAggregatesAsync(
        RiskFilterDto filter,
        CancellationToken cancellationToken = default
    );
}
