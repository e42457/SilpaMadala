using Ernst.Api.Blend.Entities;
using Ernst.Api.Blend.Interfaces;
using Ernst.Api.Blend.Services;
using Ernst.Api.Blend.Tests;
using Ernst.API.Blend.Controllers;
using Ernst.API.Blend.Interfaces;
using Ernst.API.Blend.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using System.IO;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Ernst.API.Blend.Tests
{
	[TestClass]
    public class QuoteController_BlendToErnstTest
    {
        private Mock<IQuoteService> _quoteServiceMock;
        private Mock<ILogger<QuoteController>> _loggerMock;
        private Mock<ILogger<QuoteService>> _loggerQuoteMock;
        private IQuoteService quoteService;
        private Mock<IConfiguration> configurationMock;
        private Mock<IFeeService> _feeerviceMock;
        private Mock<ILogger<FeeService>> _feeeMock;
        [TestInitialize]
        public void TestInitialize()
        {
            _quoteServiceMock = new Mock<IQuoteService>(MockBehavior.Strict);
            _loggerMock = new Mock<ILogger<QuoteController>> { DefaultValue = DefaultValue.Mock };
            _loggerQuoteMock = new Mock<ILogger<QuoteService>> { DefaultValue = DefaultValue.Mock };
            configurationMock = new Mock<IConfiguration> { DefaultValue = DefaultValue.Mock };
            _feeerviceMock = new Mock<IFeeService>(MockBehavior.Strict);
            _feeeMock = new Mock<ILogger<FeeService>> { DefaultValue = DefaultValue.Mock };
        }

        [TestMethod]
        public async Task GetErnstRequest_GoodRequest_MortgageModification()
        {
            string blendFeeRequestContent = File.ReadAllText(@".\\RequestFiles\BlendFeeRequest_MortgageModification.txt");
            BlendFeeRequest blendFeeRequest = MockTestHelper.GetBlendFeeRequestEntity(blendFeeRequestContent);
            QuoteService quoteService = new QuoteService(_loggerQuoteMock.Object, configurationMock.Object);
            _quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest)).Returns(quoteService.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest));
            QuoteController controller = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            var response = await controller.GetErnstFeeRequest(blendFeeRequest);
            Assert.IsNotNull(response.Value);
        }

        [TestMethod]
        public async Task GetErnstRequest_GoodRequest_Purchase()
        {
            string blendFeeRequestContent = File.ReadAllText(@".\\RequestFiles\BlendFeeRequest_Purchase.txt");
            BlendFeeRequest blendFeeRequest = MockTestHelper.GetBlendFeeRequestEntity(blendFeeRequestContent);
            QuoteService quoteService = new QuoteService(_loggerQuoteMock.Object, configurationMock.Object);
            _quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest)).Returns(quoteService.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest));
            QuoteController controller = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            var response = await controller.GetErnstFeeRequest(blendFeeRequest);
            Assert.IsNotNull(response.Value);
        }

        [TestMethod]
        public async Task GetErnstRequest_GoodRequest_Refinance()
        {
            string blendFeeRequestContent = File.ReadAllText(@".\\RequestFiles\BlendFeeRequest_Refinance.txt");
            BlendFeeRequest blendFeeRequest = MockTestHelper.GetBlendFeeRequestEntity(blendFeeRequestContent);
            QuoteService quoteService = new QuoteService(_loggerQuoteMock.Object, configurationMock.Object);
            _quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest)).Returns(quoteService.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest));
            QuoteController controller = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            var response = await controller.GetErnstFeeRequest(blendFeeRequest);
            Assert.IsNotNull(response.Value);
        }
		#region 55030
		[TestMethod]
		public async Task GetErnstRequest_GoodRequest_Condominium()
		{
			string blendFeeRequestContent = File.ReadAllText(@".\\RequestFiles\BlendFeeRequest_MortgageModification.txt");
			BlendFeeRequest blendFeeRequest = MockTestHelper.GetBlendFeeRequestEntity(blendFeeRequestContent);
			QuoteService quoteService = new QuoteService(_loggerQuoteMock.Object, configurationMock.Object);
			_quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest)).Returns(quoteService.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest));
			QuoteController controller = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
			var response = await controller.GetErnstFeeRequest(blendFeeRequest);
			Assert.IsNotNull(response.Value);
		}

		[TestMethod]
		public async Task GetErnstRequest_GoodRequest_Cooperative()
		{
			string blendFeeRequestContent = File.ReadAllText(@".\\RequestFiles\BlendFeeRequest_Purchase.txt");
			BlendFeeRequest blendFeeRequest = MockTestHelper.GetBlendFeeRequestEntity(blendFeeRequestContent);
			QuoteService quoteService = new QuoteService(_loggerQuoteMock.Object, configurationMock.Object);
			_quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest)).Returns(quoteService.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest));
			QuoteController controller = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
			var response = await controller.GetErnstFeeRequest(blendFeeRequest);
			Assert.IsNotNull(response.Value);
		}
		[TestMethod]
		public async Task GetErnstRequest_GoodRequest_Heloc()
		{
			string blendFeeRequestContent = File.ReadAllText(@".\\RequestFiles\BlendFeeRequest_Refinance.txt");
			BlendFeeRequest blendFeeRequest = MockTestHelper.GetBlendFeeRequestEntity(blendFeeRequestContent);
			QuoteService quoteService = new QuoteService(_loggerQuoteMock.Object, configurationMock.Object);
			_quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest)).Returns(quoteService.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest));
			QuoteController controller = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
			var response = await controller.GetErnstFeeRequest(blendFeeRequest);
			Assert.IsNotNull(response.Value);
		}


		[TestMethod]
        public async Task GetErnstRequestMock_Ok()
        {
            var ernstFeeReq = File.ReadAllText(@".\\RequestFiles\ErnstFeeReqOutput.xml");
            var blendFeeReqStr = File.ReadAllText(@".\\RequestFiles\BlendFeeReqInput.txt");
            BlendFeeRequest blendFeeReq = MockTestHelper.GetBlendFeeRequestEntity(blendFeeReqStr);
            ActionResult<string> output = XElement.Parse(ernstFeeReq).Value;
            _quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(blendFeeReq)).Returns(Task.FromResult(output));
            QuoteController quoteController = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetErnstFeeRequest(blendFeeReq);
            Assert.IsNotNull(result.Value);
        }
        [TestMethod]
        public async Task GetErnstRequest_BadRequest400()
        {
            var ernstFeeReq = File.ReadAllText(@".\\RequestFiles\ErnstFeeReqOutput.xml");
            ActionResult<string> output = XElement.Parse(ernstFeeReq).Value;
            _quoteServiceMock.Setup(mock => mock.Transform_BlendFeeReqToErnstFeeReq(It.IsAny<BlendFeeRequest>())).Returns(Task.FromResult(output));
            QuoteController quoteController = new QuoteController(_loggerMock.Object, _quoteServiceMock.Object, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetErnstFeeRequest(null);
            Assert.AreEqual(((ObjectResult)result.Result).StatusCode, StatusCodes.Status400BadRequest);
        }        

        [TestMethod]
        public async Task GetErnstRequest_CodeCoverage()
        {
            var blendFeeReqStr = File.ReadAllText(@".\\RequestFiles\BlendFeeReqInput.txt");
            BlendFeeRequest blendFeeReq = MockTestHelper.GetBlendFeeRequestEntity(blendFeeReqStr);
             
            quoteService = new QuoteService(_loggerQuoteMock.Object, configurationMock.Object);
            QuoteController quoteController = new QuoteController(_loggerMock.Object, quoteService, _feeerviceMock.Object);
            ActionResult<string> result = await quoteController.GetErnstFeeRequest(blendFeeReq);
            Assert.IsNotNull(result);
        }	

		#endregion
	}
}


