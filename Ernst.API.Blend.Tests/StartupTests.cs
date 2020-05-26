using Ernst.API.Blend;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Internal;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System;
using System.Collections.Generic;

namespace Ernst.ServiceProvider.StewartPricingApi.Tests
{
	[TestClass]
    public class StartupTests
    {
        private Mock<ILogger<Startup>> _loggerStartMock;
        private Mock<IApplicationBuilder> _appBuilderMock;
        private Mock<IHostingEnvironment> _hostEnvMock;
        private Mock<IConfiguration> _configurationMock;
        [TestInitialize]
        public void Initialize()
        {
            _loggerStartMock = new Mock<ILogger<Startup>> { DefaultValue = DefaultValue.Mock };
            _appBuilderMock = new Mock<IApplicationBuilder> { DefaultValue = DefaultValue.Mock };
            _hostEnvMock = new Mock<IHostingEnvironment> { DefaultValue = DefaultValue.Mock };
            _configurationMock = new Mock<IConfiguration> { DefaultValue = DefaultValue.Mock };
        }
        [TestMethod]
        public void TestStartup()
        {
            var servCollection = new ServiceCollection();

            IMvcBuilder mvcBuilder = new MvcBuilder(servCollection, new Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager());

            IEnumerable<KeyValuePair<string, string>> confValues = new List<KeyValuePair<string, string>>()
            {
                 new KeyValuePair<string, string>("Identity:Authority", "True"),
              new KeyValuePair<string, string>("Identity:Scope", "test")};

            ConfigurationBuilder builder = new ConfigurationBuilder();
            builder.AddInMemoryCollection(confValues);

            var confRoot = builder.Build();
            var startProcess = new Startup(_configurationMock.Object);
            startProcess.ConfigureServices(servCollection);
            Assert.IsNotNull(startProcess);
        }

        [TestMethod]
        [ExpectedException(typeof(InvalidCastException))]
        public void TestStartup_Configure()
        {
            var servCollection = new ServiceCollection();

            IMvcBuilder mvcBuilder = new MvcBuilder(servCollection, new Microsoft.AspNetCore.Mvc.ApplicationParts.ApplicationPartManager());

            IEnumerable<KeyValuePair<string, string>> confValues = new List<KeyValuePair<string, string>>()
            {
                 new KeyValuePair<string, string>("Identity:Authority", "True"),
              new KeyValuePair<string, string>("Identity:Scope", "test")};

            ConfigurationBuilder builder = new ConfigurationBuilder();
            builder.AddInMemoryCollection(confValues);

            var confRoot = builder.Build();
            var startProcess = new Startup(_configurationMock.Object);
            startProcess.Configure(_appBuilderMock.Object, _hostEnvMock.Object);
        }

    }
}
