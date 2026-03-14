namespace TradingRisk.Infrastructure.OpenSearch.Configuration;

public class OpenSearchSettings
{
    public string Uri { get; set; } = "http://localhost:9200";
    public string DefaultIndex { get; set; } = "risk-aggregates";
    public string? Username { get; set; }
    public string? Password { get; set; }
}
