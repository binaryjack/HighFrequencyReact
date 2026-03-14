using OpenSearch.Client;
using TradingRisk.Application.DTOs;
using TradingRisk.Application.Interfaces;
using TradingRisk.Domain.Entities;
using TradingRisk.Infrastructure.OpenSearch.Configuration;

namespace TradingRisk.Infrastructure.OpenSearch.Repositories;

public class RiskAggregateRepository : IRiskAggregateRepository
{
    private readonly IOpenSearchClient _client;
    private readonly OpenSearchSettings _settings;

    public RiskAggregateRepository(IOpenSearchClient client, OpenSearchSettings settings)
    {
        _client = client;
        _settings = settings;
    }

    public async Task<(List<RiskAggregate> Data, long TotalCount)> SearchAsync(
        RiskFilterDto filter,
        CancellationToken cancellationToken = default
    )
    {
        var searchRequest = new SearchRequest<RiskAggregate>(_settings.DefaultIndex)
        {
            From = filter.StartRow,
            Size = filter.EndRow - filter.StartRow,
            Query = BuildQuery(filter),
            Sort = BuildSort(filter.SortModel)
        };

        var response = await _client.SearchAsync<RiskAggregate>(searchRequest, cancellationToken);

        if (!response.IsValid)
        {
            throw new InvalidOperationException(
                $"OpenSearch query failed: {response.DebugInformation}"
            );
        }

        return (response.Documents.ToList(), response.Total);
    }

    private static QueryContainer BuildQuery(RiskFilterDto filter)
    {
        var mustClauses = new List<QueryContainer>();

        if (!string.IsNullOrEmpty(filter.Commodity))
        {
            mustClauses.Add(
                new TermQuery
                {
                    Field = Infer.Field<RiskAggregate>(f => f.Commodity),
                    Value = filter.Commodity
                }
            );
        }

        if (!string.IsNullOrEmpty(filter.Region))
        {
            mustClauses.Add(
                new TermQuery
                {
                    Field = Infer.Field<RiskAggregate>(f => f.Region),
                    Value = filter.Region
                }
            );
        }

        return mustClauses.Count == 0 ? new MatchAllQuery() : new BoolQuery { Must = mustClauses };
    }

    private static IList<ISort>? BuildSort(List<SortModelDto>? sortModel)
    {
        if (sortModel == null || sortModel.Count == 0)
        {
            return null;
        }

        return sortModel
            .Select(
                sm =>
                    new FieldSort
                    {
                        Field = new Field(sm.ColId),
                        Order = sm.Sort == "asc" ? SortOrder.Ascending : SortOrder.Descending
                    } as ISort
            )
            .ToList();
    }
}
