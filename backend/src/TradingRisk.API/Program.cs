using TradingRisk.Application.Interfaces;
using TradingRisk.Application.Services;
using TradingRisk.Infrastructure.OpenSearch.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Configure CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins(
                "http://localhost:5173", 
                "http://localhost:3000",
                "http://localhost",
                "http://frontend")
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// Configure OpenSearch
builder.Services.AddOpenSearch(settings =>
{
    settings.Uri = builder.Configuration["OpenSearch:Uri"] ?? "http://localhost:9200";
    settings.DefaultIndex = builder.Configuration["OpenSearch:DefaultIndex"] ?? "risk-aggregates";
    settings.Username = builder.Configuration["OpenSearch:Username"];
    settings.Password = builder.Configuration["OpenSearch:Password"];
});

// Register application services
builder.Services.AddScoped<IRiskAggregateService, RiskAggregateService>();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors("AllowFrontend");
app.UseAuthorization();
app.MapControllers();

app.Run();
