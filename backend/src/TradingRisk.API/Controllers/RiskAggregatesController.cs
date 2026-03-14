using Microsoft.AspNetCore.Mvc;
using TradingRisk.Application.DTOs;
using TradingRisk.Application.Interfaces;

namespace TradingRisk.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class RiskAggregatesController : ControllerBase
{
    private readonly IRiskAggregateService _service;
    private readonly ILogger<RiskAggregatesController> _logger;

    public RiskAggregatesController(
        IRiskAggregateService service,
        ILogger<RiskAggregatesController> logger
    )
    {
        _service = service;
        _logger = logger;
    }

    [HttpPost]
    public async Task<IActionResult> GetRiskAggregates(
        [FromBody] RiskFilterDto filter,
        CancellationToken cancellationToken
    )
    {
        try
        {
            var (data, totalCount) = await _service.GetRiskAggregatesAsync(
                filter,
                cancellationToken
            );

            return Ok(
                new
                {
                    data,
                    totalCount,
                    startRow = filter.StartRow,
                    endRow = filter.EndRow
                }
            );
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving risk aggregates");
            return StatusCode(500, new { error = "Internal server error" });
        }
    }
}
