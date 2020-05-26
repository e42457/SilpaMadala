using System;
using TechTalk.SpecFlow;
using System.IO;
using System.Net.Http;
using System.Collections.Generic;
using System.Xml;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Ernst.API.Blend.IntegratedTest.Settings;
using OTLS.BDD.Framework.API.Helpers;
using System.Text;
using OTLS.BDD.Framework.Common.Extensions;
using System.Net;
using OTLS.AWS.Framework.Cognito;
using OTLS.AWS.Framework.Settings;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Ernst.API.Blend.IntegratedTest.StepDefinition
{
    [Binding]
    public class API_Blend
    {
		public API_Blend(FeatureContext featureContext)
		{
			AppSettings = AppSettings.Instance;
			FeatureContext = featureContext;
		}
		private string ApiRoute { get; set; }
		private AppSettings AppSettings { get; set; }
		private string BearerToken
		{
			get
			{
				if (!FeatureContext.ContainsKey("BearerToken"))
				{
					var resp = new ClientCredentialsTokenProvider().GetToken(new ClientCredentialsFlowSettings
					{
						ClientId = AppSettings.ClientId,
						ClientSecret = AppSettings.ClientSecret,
						CognitoTokenUrl = new Uri(AppSettings.CognitoTokenUrl)
					});
					Assert.AreEqual(HttpStatusCode.OK, resp.HttpStatusCode, "Token retrieval status incorrect.");
					FeatureContext.Add("BearerToken", resp.AccessToken);
				}

				return FeatureContext.Get<string>("BearerToken");
			}
		}
		private IDictionary<string, string> DictionaryInput { get; set; }
		private FeatureContext FeatureContext { get; set; }
		private string FileContent { get; set; }
		private string RequestFile { get; set; }
		private HttpStatusCode ResponseCode { get; set; }
		private string ResponseContent { get; set; }

		[Given(@"User has Request File'(.*)'")]
		public void GivenUserHasRequestFile(string filename)
		{
			RequestFile = !string.IsNullOrWhiteSpace(filename) ? Path.Combine(AppDomain.CurrentDomain.BaseDirectory, filename) : string.Empty;
			FileContent = !string.IsNullOrWhiteSpace(filename) ? File.ReadAllText(RequestFile) : string.Empty;
		}

		[Given(@"User has Endpoint '(.*)'")]
		public void GivenUserHasEndpoint(string endpoint)
		{
			if (string.IsNullOrWhiteSpace(endpoint)) throw new ArgumentException($"{nameof(endpoint)} must be supplied, but is blank or null.");
			ApiRoute = endpoint;
		}
		
		[When(@"User has modified below  information in the  input file")]
		public void WhenUserHasModifiedBelowInformationInTheInputFile(Table table)
		{
			var DictionaryInput = table.ToDictionary<string, string>();
			FileContent = ModifyXml(RequestFile, DictionaryInput);
			Console.WriteLine(FileContent);
		}

		[When(@"User Posted the file with contentType as '(.*)'")]
		public void WhenUserPostedTheFileWithContentTypeAs(string contentType)
		{
			WhenIPostTheFileWith(contentType, false, true);			
		}

		[When(@"User Posted the file without authorization and contentType as '(.*)'")]
		public void WhenUserPostedTheFileWithoutAuthorizationAndContentTypeAs(string contentType)
		{
			WhenIPostTheFileWith(contentType, false, false);
		}

		[Then(@"Status code should be '(.*)'")]
		public void ThenStatusCodeShouldBe(string statusCode)
		{
			Assert.AreEqual(statusCode, ResponseCode.ToString(), "Response code not as expected.");
		}
		[When(@"I Post the file with contentType and addOrderHeader and authenticate as '(.*)' '(.*)' '(.*)'")]
		public void WhenIPostTheFileWith(string contentType, bool addOrderHeader, bool authenitcate)
		{
			var headers = new Dictionary<string, string>();
			if (addOrderHeader)
				headers.Add("OrderId", "156");

			if (authenitcate)
				headers.Add("Authorization", $"Bearer {BearerToken}");

			using (var client = HttpClientHelper.InitializeClient(headers.Count > 0 ? headers : null))
			{
				client.BaseAddress = AppSettings.Url;

				using (var content = new StringContent(FileContent, Encoding.UTF8, contentType))
				using (var response = client.PostAsync(ApiRoute, content).Result)
				{
					ResponseCode = response.StatusCode;
					ResponseContent = response.Content.ReadAsStringAsync().Result;
				}
			}
		}

		[Then(@"Verify Xml Response Values")]
		public void ThenVerifyXmlResponseValues(Table table)
		{
			AssertXmlValues(ResponseContent, table.ToDictionary<string, string>());
		}

		private string ModifyXml(string filename, IDictionary<string, string> dict)
		{
			var xDoc = new XmlDocument();
			xDoc.LoadXml(File.ReadAllText(filename));
			foreach (var item in dict)
			{
				Assert.IsNotNull(item.Value, $"Value for item {item.Key} is null.");

				var element = xDoc.SelectSingleNode(item.Key);
				Assert.IsNotNull(element, $"Element {item.Key} not found in xml.");

				element.InnerText = item.Value;
			}			
			return xDoc.InnerXml;			
		}

		private void AssertXmlValues(string xml, IDictionary<string, string> dict)
		{			
			var xDoc = XDocument.Parse(xml);
			foreach (var item in dict)
			{
				
				if (item.Value == "DoesnotExists")
				{
					bool xpathValidation=false;
					try
					{
						var xpathvalue = xDoc.XPathSelectElement(item.Key).Value;
						xpathValidation = true;
						Assert.AreEqual(item.Value,xpathvalue);
					}
					catch (Exception ex)
					{
						if (xpathValidation == false)
						{
							Console.WriteLine(item.Key + " Does not exists");
						}
						else
						{
							throw ex;
						}
					}
				}
				else
				{
					Assert.IsNotNull(xDoc.XPathSelectElement(item.Key), $"{item.Key} not found in xml.");
					var value = xDoc.XPathSelectElement(item.Key).Value;
					switch (item.Value)
					{
						case "CurrentDate":
							Assert.AreEqual(DateTime.Now.ToString("yyyy-MM-dd"), DateTime.Parse(value).ToString("yyyy-MM-dd"), $"Expected {item.Value} not found.");
							break;
						default:
							Assert.AreEqual(item.Value, value);
							break;
					}
				}
			}
		}
	}
}
				
