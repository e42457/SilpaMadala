using Ernst.Configuration;
using ErnstLogger;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;

namespace Ernst.API.Blend
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateWebHostBuilder(args).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .ConfigureErnstConfiguration(config => config
                .UseSwagger())
                .ConfigureErnstLogging(config => config.ConfigureInstrumentation())
                .UseStartup<Startup>();
    }
}
