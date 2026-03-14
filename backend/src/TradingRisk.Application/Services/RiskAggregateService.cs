using TradingRisk.Application.DTOs;
using TradingRisk.Application.Interfaces;
using TradingRisk.Domain.Entities;

namespace TradingRisk.Application.Services;

public class RiskAggregateService : IRiskAggregateService
{
    private readonly IRiskAggregateRepository _repository;

    public RiskAggregateService(IRiskAggregateRepository repository)
    {
        _repository = repository;
    }

    public async Task<(List<RiskAggregateDto> Data, long TotalCount)> GetRiskAggregatesAsync(
        RiskFilterDto filter,
        CancellationToken cancellationToken = default
    )
    {
        var (entities, totalCount) = await _repository.SearchAsync(filter, cancellationToken);

        var dtos = entities
            .Select(
                e =>
                    new RiskAggregateDto
                    {
                        Id = e.Id,
                        Commodity = e.Commodity,
                        Region = e.Region,
                        ProfitAndLoss = e.ProfitAndLoss,
                        VaR = e.VaR,
                        Exposure = e.Exposure,
                        TradeDate = e.TradeDate,
                        Counterparty = e.Counterparty,
                        Portfolio = e.Portfolio
                    }
            )
            .ToList();

        return (dtos, totalCount);
    }
}
