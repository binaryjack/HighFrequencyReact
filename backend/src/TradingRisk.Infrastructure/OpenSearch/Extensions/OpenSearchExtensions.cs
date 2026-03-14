using OpenSearch.Net;
using Microsoft.Extensions.DependencyInjection;
using OpenSearch.Client;
using TradingRisk.Application.Interfaces;
using TradingRisk.Infrastructure.OpenSearch.Configuration;
using TradingRisk.Infrastructure.OpenSearch.Repositories;

namespace TradingRisk.Infrastructure.OpenSearch.Extensions;

public static class OpenSearchExtensions
{
    public static IServiceCollection AddOpenSearch(
        this IServiceCollection services,
        Action<OpenSearchSettings> configureSettings
    )
    {
        var settings = new OpenSearchSettings();
        configureSettings(settings);

        services.AddSingleton(settings);

        var pool = new SingleNodeConnectionPool(new Uri(settings.Uri));
        var connectionSettings = new ConnectionSettings(pool)
            .DefaultIndex(settings.DefaultIndex)
            .ServerCertificateValidationCallback((o, cert, chain, errors) => true)
            .DisableDirectStreaming();

        if (!string.IsNullOrEmpty(settings.Username) && !string.IsNullOrEmpty(settings.Password))
        {
            connectionSettings.BasicAuthentication(settings.Username, settings.Password);
        }

        var client = new OpenSearchClient(connectionSettings);
        services.AddSingleton<IOpenSearchClient>(client);

        services.AddScoped<IRiskAggregateRepository, RiskAggregateRepository>();

        return services;
    }
}
