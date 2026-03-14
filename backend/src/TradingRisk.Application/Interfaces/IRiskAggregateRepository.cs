using TradingRisk.Application.DTOs;
using TradingRisk.Domain.Entities;

namespace TradingRisk.Application.Interfaces;

public interface IRiskAggregateRepository
{
    Task<(List<RiskAggregate> Data, long TotalCount)> SearchAsync(
        RiskFilterDto filter,
        CancellationToken cancellationToken = default
    );
}
