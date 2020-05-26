using Ernst.Api.Blend.Interfaces;
using Ernst.Api.Blend.Services;
using Ernst.API.Blend.Controllers;
using Ernst.API.Blend.Interfaces;
using Ernst.API.Blend.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Ernst.Api.Blend.Tests
{
	[TestClass]
    public class QuoteControllerTests
    {
        private Mock<IQuoteService> _quoteServiceMock;
        private Mock<ILogger<QuoteController>> _loggerMock;
        private Mock<ILogger<QuoteService>> _loggerQuoteMock;
        private IQuoteService quoteService;
        private Mock<IConfiguration> _configurationMock;
        private Mock<IFeeService> _feeerviceMock;
        private Mock<ILogger<FeeService>> _feeeMock;
        public QuoteControllerTests()
        {
            _quoteServiceMock = new Mock<IQuoteService>(MockBehavior.Strict);
            _loggerMock = new Mock<ILogger<QuoteController>> { DefaultValue = DefaultValue.Mock };
            _loggerQuoteMock = new Mock<ILogger<QuoteService>> { DefaultValue = DefaultValue.Mock };
            _configurationMock = new Mock<IConfiguration> { DefaultValue = DefaultValue.Mock };
            _feeerviceMock = new Mock<IFeeService>(MockBehavior.Strict);
            _feeeMock = new Mock<ILogger<FeeService>> { DefaultValue = DefaultValue.Mock };
            
        }

        [TestMethod]
        public async Task GetBlendResponse_MockService()
        {
            var ernstFeeResponse = File.ReadAllText(@".\\RequestFiles\ErsntFeeResponse.txt");
            var blendResponse = File.ReadAllText(@".\\RequestFiles\GetFeesForHomeLoanProductResponse.xml");
            ActionResult<string> output = XElement.Parse(blendResponse).Value;
            XElement xElement = XElement.Parse(ernstFeeResponse);
            _quoteServiceMock.Setup(mock => mock.TransformErnstFeeResponse(It.IsAny<XElement>())).Returns(Task.FromResult(output));
            QuoteController quoteController = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetBlendFeeResponse(xElement);
            Assert.IsNotNull(result);
        }
        [TestMethod]
        public async Task GetBlendResponse_NullInput()
        {
            var blendResponse = File.ReadAllText(@".\\RequestFiles\GetFeesForHomeLoanProductResponse.xml");
            ActionResult<string> output = XElement.Parse(blendResponse).Value;
            _quoteServiceMock.Setup(mock => mock.TransformErnstFeeResponse(It.IsAny<XElement>())).Returns(Task.FromResult(output));
            QuoteController quoteController = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetBlendFeeResponse(null);
            Assert.AreEqual(((ObjectResult)result.Result).StatusCode, (int)HttpStatusCode.BadRequest);
        }
        [TestMethod]
        public async Task GetBlendResponse()
        {
            var ernstFeeResponse = File.ReadAllText(@".\\RequestFiles\ErsntFeeResponse.txt");
            XElement xElement = XElement.Parse(ernstFeeResponse);
            quoteService = new QuoteService(_loggerQuoteMock.Object, _configurationMock.Object);
            QuoteController quoteController = new QuoteController(_loggerMock.Object, quoteService, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetBlendFeeResponse(xElement);
            Assert.IsNotNull(result);
        }
        [TestMethod]
        public async Task GetBlendResponse_WithSplits()
        {
            var ernstFeeResponse = File.ReadAllText(@".\\RequestFiles\ErsntFeeResponse_Splits.txt");
            XElement xElement = XElement.Parse(ernstFeeResponse);
            quoteService = new QuoteService(_loggerQuoteMock.Object, _configurationMock.Object);
            QuoteController quoteController = new QuoteController(_loggerMock.Object, quoteService, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetBlendFeeResponse(xElement);
            Assert.IsNotNull(result);
        }
        [TestMethod]
        public async Task GetBlendResponse_NoRecords()
        {
            var ernstFeeResponse = File.ReadAllText(@".\\RequestFiles\ErsntFeeResponse_NoRecords.txt");
            XElement xElement = XElement.Parse(ernstFeeResponse);
            quoteService = new QuoteService(_loggerQuoteMock.Object, _configurationMock.Object);
            QuoteController quoteController = new QuoteController(_loggerMock.Object, quoteService, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetBlendFeeResponse(xElement);
            Assert.IsNotNull(result);
        }
        [TestMethod]
        public async Task GetFeeService_MockService()
        {
            var feeRequest = File.ReadAllText(@".\\RequestFiles\Ernst Fee Service Request.xml");
            _feeerviceMock.Setup(mock => mock.GetErnstFeeResponse(It.IsAny<XElement>())).Returns(() => MockTestHelper.GetFeeResponsefromJson());
            QuoteController quoteController = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            string OrderId = "44544854184";
            ActionResult<string> result = await quoteController.ErnstFeeQuoteRequest(XElement.Parse(feeRequest), OrderId);
            Assert.IsNotNull(result.Value);
        }

        [TestMethod]
        public async Task GetFeeService_MockServiceBadRequest()
        {
            _feeerviceMock.Setup(mock => mock.GetErnstFeeResponse(It.IsAny<XElement>())).Returns(() => MockTestHelper.GetFeeResponsefromJson());
            QuoteController quoteController = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            string OrderId = "44544854184";
            ActionResult<string> result = await quoteController.ErnstFeeQuoteRequest(null, OrderId);
            Assert.AreEqual(((ObjectResult)result.Result).StatusCode, (int)HttpStatusCode.BadRequest);
        }
        [TestMethod]
        public async Task GetFeeService_MockServiceBadGateway()
        {
            var feeRequest = File.ReadAllText(@".\\RequestFiles\Ernst Fee Service Request.xml");
            _feeerviceMock.Setup(mock => mock.GetErnstFeeResponse(It.IsAny<XElement>())).Returns(() => MockTestHelper.GetErnstFeeResponsefromJson());
            QuoteController quoteController = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            string OrderId = "44544854184";
            ActionResult<string> result = await quoteController.ErnstFeeQuoteRequest(XElement.Parse(feeRequest), OrderId);
            Assert.AreEqual(((ObjectResult)result.Result).StatusCode, (int)HttpStatusCode.BadGateway);
        }
        [TestMethod]
        public async Task GetErnstFeeService_MockService()
        {
            var feeRequest = File.ReadAllText(@".\\RequestFiles\Ernst Fee Service Request.xml");
            FeeService feeService = new FeeService(_feeeMock.Object, _configurationMock.Object);
            ActionResult<string> result = await feeService.GetErnstFeeResponse(XElement.Parse(feeRequest));
            Assert.IsNotNull(result);
        }
        [TestMethod]
        public async Task GetErnstFeeService_Mock()
        {
            var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("Ernst.Api.Blend.Tests.Development.json")
            .Build();
            var feeRequest = File.ReadAllText(@".\\RequestFiles\Ernst Fee Service Request.xml");
            FeeService feeService = new FeeService(_feeeMock.Object, configuration);
            ActionResult<string> result = await feeService.GetErnstFeeResponse(XElement.Parse(feeRequest));
            Assert.IsNotNull(result.Value);
        }
    }
}
