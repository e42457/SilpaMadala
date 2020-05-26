using Ernst.Api.Blend.Helpers;
using Ernst.Api.Blend.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Ernst.Api.Blend.Services
{
	public class FeeService : IFeeService
    {
        private readonly ILogger<FeeService> _logger;
        private readonly IConfiguration _configuration;
        public FeeService(ILogger<FeeService> logger, IConfiguration configuration)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _configuration = configuration;
        }

        public async Task<string> GetErnstFeeResponse(XElement feeServiceRequest)
        {
            var endpoint = _configuration.GetSection("Ernst")["FeeServiceEndpoint"];
            if (string.IsNullOrEmpty(endpoint))
            {
                _logger.LogError("feeservice endpoint is not configured in configuration file");
                return new ObjectResult("")
                {
                    StatusCode = (int)HttpStatusCode.InternalServerError
                }.ToString();
            }
            using (var client = new HttpClient())
            {
                var values = new Dictionary<string, string>
                 {
                    { "xmlRequest", feeServiceRequest.ToString() }
                 };

                var content = new FormUrlEncodedContent(values);

                var response = await client.PostAsync(endpoint, content);

                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogError("feeservice is not responding ", response);
                    return null;
                }
                var responseString = await response.Content.ReadAsStringAsync();

                var Content = System.Web.HttpUtility.HtmlDecode(responseString.ToString());

                var updatedFeeResponse = FormatHelper.RemoveNameSpaces(XElement.Parse(Content));

                var feeresponse = FormatHelper.RemoveXmlDefinition(updatedFeeResponse.ToString());

                return feeresponse;
            }

        }
    }
}

