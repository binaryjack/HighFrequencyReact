namespace TradingRisk.Application.DTOs;

public class RiskFilterDto
{
    public string? Commodity { get; set; }
    public string? Region { get; set; }
    public int StartRow { get; set; } = 0;
    public int EndRow { get; set; } = 100;
    public List<SortModelDto>? SortModel { get; set; }
}

public class SortModelDto
{
    public string ColId { get; set; } = string.Empty;
    public string Sort { get; set; } = "asc";
}
