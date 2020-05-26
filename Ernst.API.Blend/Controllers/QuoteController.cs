using Ernst.Api.Blend.Entities;
using Ernst.Api.Blend.Interfaces;
using Ernst.API.Blend.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Net;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Ernst.API.Blend.Controllers
{
	[Route("quote")]
    [ApiController]
    [Authorize]
    public class QuoteController : ControllerBase
    {
        private readonly ILogger<QuoteController> _logger;
        private readonly IQuoteService _quoteService;
        private readonly IFeeService _feeService;

        public QuoteController(ILogger<QuoteController> logger,IQuoteService quoteService, IFeeService feeService)
        {
            _logger = logger;
            _quoteService = quoteService;
            _feeService = feeService;
        }

        [HttpPost]
        [Route("request")]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<string>> GetErnstFeeRequest(BlendFeeRequest blendFeeRequest, string orderId = null) 
        {
            _logger.LogInformation("The Method GetErnstFeeRequest Started.");
            if (blendFeeRequest == null)
            {
                _logger.LogError($"Input Xml cannot be Empty.");
                return new ObjectResult($"Input Xml cannot be Empty.")
                {
                    StatusCode = (int)HttpStatusCode.BadRequest
                };
            }
            var ernstReq = await _quoteService.Transform_BlendFeeReqToErnstFeeReq(blendFeeRequest);
            return await Task.FromResult(ernstReq);
        }


        /// <summary>
        /// Accepts the ErnstFeeResponse and transforms to BlendFeeResponse
        /// </summary>
        /// <param name="ernstFeeResponse">ErnstFeeResponse as XML Input</param>
        /// <returns>BlendFeeResponse as XML output</returns>
        [HttpPost]
        [Route("Response")]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<string>> GetBlendFeeResponse(XElement ernstFeeResponse)
        {
            _logger.LogInformation("The Method GetBlendFeeResponse Started.");
            if (ernstFeeResponse == null)
            {
                _logger.LogError($"Input Xml cannot be Empty.");
                return new ObjectResult("")
                {
                    StatusCode = (int)HttpStatusCode.BadRequest
                };
            }
            _logger.LogInformation("The Transformation to the BlendFee started");
            var blendResponse = await _quoteService.TransformErnstFeeResponse(ernstFeeResponse);
            return await Task.FromResult(blendResponse);
        }

        /// <summary>
        /// This Ernst Fee Service quote Endpoint will get the ErnstFeserviceQuote Response XML
        /// </summary>
        /// <param name="feeServiceRequest">FeeServiceRequest XML</param>
        /// <param name="orderId">OrderID</param>
        /// <returns>Returns the output as FeeServiceQuote Response XML</returns>
        [HttpPost]
        [Route("feeservicequote")]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<ActionResult<string>> ErnstFeeQuoteRequest([FromBody] XElement feeServiceRequest, [FromHeader(Name = "OrderID")] string orderId)
        {
            if (feeServiceRequest == null)
            {
                _logger.LogError("Input XML cannot be Empty.");
                return new ObjectResult("Input XML cannot be Empty.")
                {
                    StatusCode = (int)HttpStatusCode.BadRequest
                };
            }
            var feeResponseresult = await _feeService.GetErnstFeeResponse(feeServiceRequest);

            if (feeResponseresult == null)
            {
                _logger.LogError($"No Response from FeeService url.");
                return new ObjectResult("")
                {
                    StatusCode = (int)HttpStatusCode.BadGateway
                };
            }
            return await Task.FromResult(feeResponseresult);
        }
    }
}
