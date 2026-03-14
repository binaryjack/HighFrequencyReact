namespace TradingRisk.Application.DTOs;

public class RiskAggregateDto
{
    public string Id { get; set; } = string.Empty;
    public string Commodity { get; set; } = string.Empty;
    public string Region { get; set; } = string.Empty;
    public decimal ProfitAndLoss { get; set; }
    public decimal VaR { get; set; }
    public decimal Exposure { get; set; }
    public DateTime TradeDate { get; set; }
    public string Counterparty { get; set; } = string.Empty;
    public string Portfolio { get; set; } = string.Empty;
}
