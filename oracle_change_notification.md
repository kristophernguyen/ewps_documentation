using Microsoft.AspNetCore.SignalR;

public class ChangeNotificationHub : Hub
{
    // Hub methods, if needed
}

//------------------------------------------------------

using Oracle.ManagedDataAccess.Client;
using System;
using System.Data;
using System.Threading;
using System.Threading.Tasks;

public interface IOracleChangeNotificationService
{
    Task StartChangeNotificationAsync(CancellationToken cancellationToken);
}

public class OracleChangeNotificationService : IOracleChangeNotificationService
{
    private readonly IHubContext<ChangeNotificationHub> _hubContext;
    private readonly string _connectionString;

    public OracleChangeNotificationService(IHubContext<ChangeNotificationHub> hubContext, string connectionString)
    {
        _hubContext = hubContext;
        _connectionString = connectionString;
    }

    public async Task StartChangeNotificationAsync(CancellationToken cancellationToken)
    {
        using (var connection = new OracleConnection(_connectionString))
        {
            await connection.OpenAsync(cancellationToken);

            using (var command = connection.CreateCommand())
            {
                // Configure OracleDependency for change notification
                var dependency = new OracleDependency(command);
                dependency.OnChange += (sender, eventArgs) =>
                {
                    // Notify clients using SignalR when a change occurs
                    _hubContext.Clients.All.SendAsync("DataChanged", "Database data changed");
                };

                // Set up query for change notification
                command.CommandText = "SELECT * FROM YourTable";
                command.Notification = dependency;
                command.CommandType = CommandType.Text;

                // Start OracleDependency to listen for changes
                command.ExecuteNonQuery();
            }

            // Keep the connection open to receive notifications
            while (!cancellationToken.IsCancellationRequested)
            {
                await Task.Delay(1000, cancellationToken);
            }
        }
    }
}


//--------------------------------------------------------------------------------------

public void ConfigureServices(IServiceCollection services)
{
    // Other service registrations

    services.AddSignalR();
    services.AddSingleton<IOracleChangeNotificationService>(provider =>
    {
        var connectionString = Configuration.GetConnectionString("OracleConnection");
        var hubContext = provider.GetRequiredService<IHubContext<ChangeNotificationHub>>();
        return new OracleChangeNotificationService(hubContext, connectionString);
    });
}

public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    // Other configurations

    app.UseEndpoints(endpoints =>
    {
        endpoints.MapHub<ChangeNotificationHub>("/changenotificationhub");
        endpoints.MapBlazorHub();
        endpoints.MapFallbackToPage("/_Host");
    });

    // Start the Oracle change notification service when the application starts
    var oracleService = app.ApplicationServices.GetRequiredService<IOracleChangeNotificationService>();
    var cancellationToken = app.ApplicationServices.GetRequiredService<IHostApplicationLifetime>().ApplicationStopping;
    Task.Run(() => oracleService.StartChangeNotificationAsync(cancellationToken));
}
