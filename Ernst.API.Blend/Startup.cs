using Ernst.Api.Blend.Interfaces;
using Ernst.Api.Blend.Services;
using Ernst.API.Blend.Interfaces;
using Ernst.API.Blend.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System.Threading.Tasks;

namespace Ernst.API.Blend
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public static IConfiguration Configuration { get; private set; }

        public void ConfigureServices(IServiceCollection services)
        {

            services.AddMvc().AddXmlSerializerFormatters();
            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddTransient<IQuoteService, QuoteService>();
            services.AddSingleton<IFeeService, FeeService>();
            services.AddAuthentication("Bearer")
                  .AddIdentityServerAuthentication(options =>
                  {
                      options.Authority = Configuration.GetSection("Identity")["Authority"];
                      options.RequireHttpsMetadata = true;
                      options.ApiName = Configuration.GetSection("Identity").GetSection("Scope").Value;
                  });

            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
        }

        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }
            app.UseAuthentication();
            app.UseExceptionHandler(options =>
            {
                options.Run(context =>
                {
                    return Task.CompletedTask;
                });
            });
            app.UseHttpsRedirection();
            app.UseMvc();
        }
    }
}
