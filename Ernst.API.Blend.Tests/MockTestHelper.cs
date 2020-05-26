using Ernst.Api.Blend.Entities;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Xml.Serialization;

namespace Ernst.Api.Blend.Tests
{
	public static class MockTestHelper
    {

        public static BlendFeeRequest GetBlendFeeRequestEntity(string blendFeeReq)
        {
            BlendFeeRequest feeServiceRequest = new BlendFeeRequest();
            try
            {
                XmlSerializer serializer = new XmlSerializer(typeof(BlendFeeRequest));

                using (TextReader reader = new StringReader(blendFeeReq))
                {
                    feeServiceRequest = (BlendFeeRequest)serializer.Deserialize(reader);
                }
            }
            catch
            {
            }
            return feeServiceRequest;
        }
              
        public static async Task<string> GetFeeResponsefromJson()
        {
            var SoapResponse = File.ReadAllText(@".\\RequestFiles\Ernst Fee Service Response.xml");
            return await Task.FromResult(SoapResponse);
        }
        public static async Task<string> GetErnstFeeResponsefromJson()
        {
            var feeServiceRequest = File.ReadAllText(@".\\RequestFiles\Ernst Fee Service Request.xml");
            using (var client = new HttpClient())
            {
                var values = new Dictionary<string, string>
                 {
                    { "xmlRequest", feeServiceRequest.ToString() }
                 };

                var content = new FormUrlEncodedContent(values);

                var response = await client.PostAsync("http://feeservice.ernstinfo.com/stg/processxml.asmx", content);

                if (!response.IsSuccessStatusCode)
                {
                    return null;
                }
                var responseString = await response.Content.ReadAsStringAsync();

                return System.Web.HttpUtility.HtmlDecode(responseString.ToString());
            }
        }
    }
}
