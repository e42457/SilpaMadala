using Ernst.Api.Blend.Entities;
using Ernst.Api.Blend.Helpers;
using Ernst.API.Blend.Interfaces;
using Ernst.API.Blend.Utilities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using static Ernst.Api.Blend.Entities.BlendFeeResponse;
using static Ernst.API.Blend.Utilities.Enumerations;

namespace Ernst.API.Blend.Services
{
    public class QuoteService : IQuoteService
	{
		private ILogger<QuoteService> _logger;
		private IConfiguration _configuration;

		public QuoteService(ILogger<QuoteService> logger, IConfiguration configuration)
		{
			_logger = logger;
			_configuration = configuration;
		}

        public async Task<ActionResult<string>> Transform_BlendFeeReqToErnstFeeReq(BlendFeeRequest blendFeeReq)
        {
            var ernstFeeReq = new ErnstFeeRequest
            {
                Version = Convert.ToDecimal(_configuration.GetSection("General").GetSection("Version").Value),
                ClientTransactionID = blendFeeReq?.RequestId,
                TransactionDate = DateTime.Now.Date,
                Authentication = new Authentication()
                {
                    UserID = _configuration.GetSection("Authontication").GetSection("UserID").Value,
                    Password = _configuration.GetSection("Authontication").GetSection("Password").Value
                },

                RequestInfo = new RequestInfo
                {
                    Loan = new Loan
                    {
                        ApplicationDate = DateTime.Now.Date,
                        LoanPurpose = blendFeeReq?.HomeLoanApplication?.HomeLoan?.Purpose.ToString(),
                        RateType = blendFeeReq?.HomeLoanApplication?.HomeLoan?.Product?.AmortizationType,
                        RefinanceSameLender = Convert.ToBoolean(blendFeeReq?.HomeLoanApplication?.HomeLoan?.SameLenderRefinance)
                    },
                    Property = new ErnstProperty
                    {
                        PropertyUse = blendFeeReq?.HomeLoanApplication?.Property?.PropertyUsageType
                    }
                },
                ErnstRequest = new ErnstRequest
                {
                    Version = "1",
                    TransactionCode = "100",
                    Property = new ErnstRequestProperty
                    {
                        City = (blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.State.ToUpper() == "CT" ||
                                    blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.State.ToUpper() == "RI" ||
                                    blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.State.ToUpper() == "VT") ? "x" :
                                    blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.City,
                        County = GetCounty(blendFeeReq),
                        State = blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.State,
                        EstimatedValue = GetEstimatedValue(blendFeeReq),
                        MortgageAmount = blendFeeReq?.HomeLoanApplication?.HomeLoan?.LoanAmount
                    }
                },
                TitleRequest = new TitleRequest
                {
                    Version = "2",
                    Property = new TitleRequestProperty
                    {
                        City = blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.City,
                        County = GetCounty(blendFeeReq),
                        State = blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.State,
                        Zip = blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.PostalCode
                    },
                    LendersPolicy = new LendersPolicy
                    {
                        PolicyAmount = blendFeeReq?.HomeLoanApplication?.HomeLoan?.LoanAmount
                    }
                }
            };

            if (blendFeeReq?.HomeLoanApplication?.Borrowers?.BorrowerLst.Count > 0 && !string.IsNullOrWhiteSpace(blendFeeReq?.HomeLoanApplication?.Borrowers?.BorrowerLst[0].FirstTimeHomeBuyer))
            {
                ernstFeeReq.RequestInfo.Loan.FirstTimeHomeBuyer = Convert.ToBoolean(blendFeeReq?.HomeLoanApplication?.Borrowers?.BorrowerLst[0].FirstTimeHomeBuyer);
            }
            if (!string.IsNullOrWhiteSpace(blendFeeReq?.HomeLoanApplication?.Property?.NumberOfUnits) && (blendFeeReq?.HomeLoanApplication?.Property?.NumberOfUnits != "0"))
            {
                ernstFeeReq.RequestInfo.Property.NumberOfUnits = blendFeeReq.HomeLoanApplication.Property.NumberOfUnits;
            }

            if (blendFeeReq?.HomeLoanApplication?.HomeLoan?.LienType.ToLower().Trim() == EnumLienType.HELOC.ToString().ToLower())
                ernstFeeReq.RequestInfo.Loan.HELOC = true;
            else
                ernstFeeReq.RequestInfo.Loan.HELOC = false;

            if (blendFeeReq?.HomeLoanApplication?.Property?.PropertyType?.ToLower().Trim() == EnumProjectLegalStructure.Condominium.ToString().ToLower())
            {
                ernstFeeReq.RequestInfo.Property.ProjectLegalStructure = EnumProjectLegalStructure.Condominium.ToString();
            }
            else if (blendFeeReq?.HomeLoanApplication?.Property?.PropertyType?.ToLower().Trim() == EnumProjectLegalStructure.Cooperative.ToString().ToLower())
            {
                ernstFeeReq.RequestInfo.Property.ProjectLegalStructure = EnumProjectLegalStructure.Cooperative.ToString();
            }
            else
            {
                ernstFeeReq.RequestInfo.Property.ProjectLegalStructure = EnumProjectLegalStructure.Unknown.ToString();
            }

            ernstFeeReq.ErnstRequest.NumberOfPages = new NumberOfPages();
            ernstFeeReq.ErnstRequest.Mortgage = new Mortgage();
            ernstFeeReq.ErnstRequest.Deed = new Deed();

            if (blendFeeReq?.HomeLoanApplication?.HomeLoan?.Purpose == Enumerations.MismoLoanPurpose.MortgageModification.ToString())
            {
                ernstFeeReq.ErnstRequest.NumberOfPages.Mortgage = string.Empty;
                ernstFeeReq.ErnstRequest.Mortgage.AmendmentModificationPages = "30";
                ernstFeeReq.ErnstRequest.Deed.AmendmentModificationPages = "3";
            }
            else
            {
                ernstFeeReq.ErnstRequest.NumberOfPages.Mortgage = "30";
                ernstFeeReq.ErnstRequest.Mortgage.AmendmentModificationPages = string.Empty;
                ernstFeeReq.ErnstRequest.Deed.AmendmentModificationPages = string.Empty;
            }

            ernstFeeReq.TitleRequest.OwnersPolicy = new OwnersPolicy();

            if (blendFeeReq?.HomeLoanApplication?.HomeLoan?.Purpose == Enumerations.MismoLoanPurpose.MortgageModification.ToString() ||
              blendFeeReq?.HomeLoanApplication?.HomeLoan?.Purpose == Enumerations.MismoLoanPurpose.Refinance.ToString())
            {
                ernstFeeReq.ErnstRequest.NumberOfPages.Deed = string.Empty;
                ernstFeeReq.TitleRequest.Property.LoanType = "refinance";
                ernstFeeReq.TitleRequest.OwnersPolicy.Requested = "false";
                ernstFeeReq.TitleRequest.UseSimultaneousRates = "false";
            }
            else
            {
                ernstFeeReq.ErnstRequest.NumberOfPages.Deed = "3";
                ernstFeeReq.TitleRequest.OwnersPolicy.Requested = "true";
                ernstFeeReq.TitleRequest.OwnersPolicy.PolicyAmount = blendFeeReq?.HomeLoanApplication?.HomeLoan?.PurchasePrice;
                ernstFeeReq.TitleRequest.Property.LoanType = "sale";
                ernstFeeReq.TitleRequest.UseSimultaneousRates = "true";
            }

            ernstFeeReq.TitleRequest.LendersPolicy.Requested = "true";
            ernstFeeReq.TitleRequest.Property.PolicyType = "new";
            ernstFeeReq.TitleRequest.ItemizedSettlementFees = new ItemizedSettlementFees
            {
                Requested = "true"
            };
            ernstFeeReq.TitleRequest.UseCommonEndorsements = "true";

            if (blendFeeReq?.HomeLoanApplication?.HomeLoan?.Purpose == Enumerations.MismoLoanPurpose.Refinance.ToString())
            {
                ernstFeeReq.ErnstRequest.Release = new Release
                {
                    Pages = "4",
                    NumberOfReleases = "1"
                };
            }

            var ernstFeeReqXml = FormatHelper.Serialize(ernstFeeReq);
            var result = FormatHelper.RemoveNameSpaces(XElement.Parse(ernstFeeReqXml));
            return await Task.FromResult(result.ToString());
        }

		private string GetCounty(BlendFeeRequest blendFeeReq)
		{
			string county = blendFeeReq?.HomeLoanApplication?.Property?.PropertyAddress?.County;
			if (string.IsNullOrEmpty(county))
				return string.Empty;

			county = county.Replace("-", "");
			county = county.Replace("City and Borough", "", true, System.Globalization.CultureInfo.CurrentCulture);
			county = county.Replace("Census Area", "", true, System.Globalization.CultureInfo.CurrentCulture);
			county = county.Replace("County", "", true, System.Globalization.CultureInfo.CurrentCulture);
			county = county.Replace("Borough", "", true, System.Globalization.CultureInfo.CurrentCulture);
			county = county.Replace("Municipality", "", true, System.Globalization.CultureInfo.CurrentCulture);
			county = county.Replace("Parish", "", true, System.Globalization.CultureInfo.CurrentCulture);
			return county.Trim();
		}

		private string GetEstimatedValue(BlendFeeRequest blendFeeReq)
		{
            if (blendFeeReq?.HomeLoanApplication?.HomeLoan?.Purpose == Enumerations.MismoLoanPurpose.Refinance.ToString())
            {
                return string.Empty;
            }

            if (string.IsNullOrEmpty(blendFeeReq?.HomeLoanApplication?.Property?.AppraisedValue) && string.IsNullOrEmpty(blendFeeReq?.HomeLoanApplication?.Property?.PurchasePrice))
            {
                return string.Empty;
            }

            if (string.IsNullOrEmpty(blendFeeReq?.HomeLoanApplication?.Property?.AppraisedValue))
            {
                blendFeeReq.HomeLoanApplication.Property.AppraisedValue = "0";
            }

            if (string.IsNullOrEmpty(blendFeeReq?.HomeLoanApplication?.Property?.PurchasePrice))
            {
                blendFeeReq.HomeLoanApplication.Property.PurchasePrice = "0";
            }
          
            if (decimal.Parse(blendFeeReq?.HomeLoanApplication?.Property?.AppraisedValue) > decimal.Parse(blendFeeReq?.HomeLoanApplication?.Property?.PurchasePrice))
            {
                return blendFeeReq?.HomeLoanApplication?.Property?.AppraisedValue;
            }
            else
            {
                return blendFeeReq?.HomeLoanApplication?.Property?.PurchasePrice;
            }
		}

		private XmlDocument ConvertToXmlDocument(XElement value, XmlDocument xmlDoc)
		{
			XElement ernstFeeResponse;
			XmlReader reader = value.CreateReader();
			reader.MoveToContent();
			if (reader.Name.ToLower() != "response")
				ernstFeeResponse = XElement.Parse(Convert.ToString(reader.ReadInnerXml()));
			else
				ernstFeeResponse = XElement.Parse(Convert.ToString(value));
			ernstFeeResponse = FormatHelper.RemoveNameSpaces(ernstFeeResponse);
			xmlDoc.LoadXml(ernstFeeResponse.ToString());
			return xmlDoc;
		}
		public async Task<ActionResult<string>> TransformErnstFeeResponse(XElement value)
		{
			var xmlDoc = new XmlDocument();
			try
			{
				xmlDoc = ConvertToXmlDocument(value, xmlDoc);
			}
			catch (Exception ex)
			{
				_logger.LogError($"Invalid Input Xml. {value.Value}-{ex.Message}");
				return new ObjectResult("")
				{
					StatusCode = (int)HttpStatusCode.BadRequest
				};
			}
			var blendFee = new HomeLoanResponse();
			if (xmlDoc.InnerXml != null)
			{
				blendFee = new HomeLoanResponse
				{
					Version = "1",
					RequestId = xmlDoc?.SelectSingleNode("//ClientTransactionID")?.InnerText
				};
				XmlNodeList nodeList = xmlDoc?.SelectNodes("//Error");
				if (nodeList?.Count > 0)
				{
					blendFee.ResponseStatus = Enumerations.ResponseStatus.ServerErrorFatal.ToString();
					blendFee.SystemMessage = GetSystemMessage(xmlDoc);
				}
				else
				{
					blendFee.ResponseStatus = "Success";
				}
				blendFee.Body = GetAllRecordings(xmlDoc);
				blendFee.Body.FeeList?.Fee?.AddRange(GetTransferTaxes(xmlDoc));
				blendFee.Body.FeeList?.Fee?.AddRange(GetSettlementFee(xmlDoc));
				blendFee.Body.FeeList?.Fee.AddRange(GetLenderPolicy(xmlDoc));
				blendFee.Body.FeeList?.Fee.AddRange(GetOwnerPolicy(xmlDoc));
				blendFee.Body.FeeList?.Fee?.AddRange(GetEndrosements(xmlDoc));
			}
			var feeServiceResponseXml = blendFee.Body != null ? FormatHelper.Serialize(blendFee) : null;
			var result = feeServiceResponseXml != null ? FormatHelper.RemoveNameSpaces(XElement.Parse(feeServiceResponseXml)) : null;
			result?.Descendants()?.Where(e => string.IsNullOrEmpty(e?.Value))?.Remove();
			return await Task.FromResult(result?.ToString());
		}
		private string GetSystemMessage(XmlDocument xmlDoc)
		{
			string errorcode = string.Empty;
			string ErrDesc = string.Empty;
			StringBuilder errorMessages = new StringBuilder();
			XmlNodeList nodeList = xmlDoc.SelectNodes("//Error");
			foreach (XmlNode ele in nodeList)
			{
				errorcode = ele["Code"]?.InnerText;
				ErrDesc = ele["Description"]?.InnerText;
				errorMessages.Append("[" + errorcode + "] " + ErrDesc + " | ");
			}
			return errorMessages?.ToString()?.TrimEnd(' ').TrimEnd('|').TrimEnd(' ');
		}

		#region Recording Fees

		private Body GetAllRecordings(XmlDocument xmlDoc)
		{
			return new Body()
			{
				FeeList = new Fees()
				{
					Fee = new List<Fee>()
					{
						GetRecordingDeed(xmlDoc),
						GetRecordingMortgage(xmlDoc),
						GetRecordingRelease(xmlDoc),
						GetRecordingAssignment(xmlDoc),
						GetRecordingPoa(xmlDoc),
						GetRecordingSubordination(xmlDoc),
						GetRecordingNotorial(xmlDoc),
						GetRecordingResidential(xmlDoc),
						GetRecordingOther(xmlDoc)
					}
				}
			};
		}
		private Fee GetRecordingDeed(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/Deed2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingDeed");
				return fee;
			}
			else return fee;
		}
		private Fee GetRecordingMortgage(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/Mortgage2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingMortgage");
				return fee;
			}
			else return fee;
		}
		private Fee GetRecordingRelease(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/Release2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingRelease");
				return fee;
			}
			else return fee;
		}
		private Fee GetRecordingAssignment(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/Assignment2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingAssignment");
				return fee;
			}
			else return fee;
		}
		private Fee GetRecordingPoa(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/POA2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingPOA");
				return fee;
			}
			else return fee;
		}
		private Fee GetRecordingSubordination(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/Subordination2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingSubordination");
				return fee;
			}
			else return fee;
		}
		private Fee GetRecordingNotorial(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/Notorial2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingNotorial");
				return fee;
			}
			else return fee;
		}
		private Fee GetRecordingResidential(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/ResidentialMortgage2010");
			var fee = new Fee();
			if (feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingResidentialMortgage");
				return fee;
			}
			else return fee;
		}

		private Fee GetRecordingOther(XmlDocument ernstFeeResp)
		{
			var feeDetail = ernstFeeResp.SelectNodes("//HUDRESPA2010/HUDLine1202/Other2010");
			var fee = new Fee();
			if (feeDetail != null && feeDetail.Count > 0)
			{
				fee = GetCommonValues(feeDetail, "RecordingOther");
				return fee;
			}
			else return fee;
		}
		private Fee GetCommonValues(XmlNodeList feeDetail, string referenceId)
		{
			var fee = new Fee()
			{
				LoanEstSection = "E",
				HudLineNum = "1202",
				IncludedInApr = "false",
				PaidBy = "Borrower"
			};
			fee.ReferenceId = referenceId;
			foreach (XmlNode ele in feeDetail)
			{
				fee.Name = ele["LineDescription"]?.InnerText;
				fee.Amount = ele["Amount"]?.InnerText;
			}
			return fee;
		}

		#endregion Recording Fee

		#region Transfer Tax
		private List<Fee> GetTransferTaxes(XmlDocument xmlDoc)
		{
			var taxList = xmlDoc?.SelectNodes("//CFPB2015/CFPBTax");
			var feelist = new List<Fee>();
			if (taxList != null && taxList.Count > 0)
			{
				feelist = GetTaxingEntities(taxList, feelist);
				return feelist;
			}
			return feelist;
		}
		private List<Fee> GetTaxingEntities(XmlNodeList taxList, List<Fee> feelist)
		{
			foreach (XmlNode taxes in taxList)
			{
				var nodeList = taxes["TaxingEntities"]?.ChildNodes;
				if (nodeList != null && nodeList?.Count > 0)
				{
					GetTaxChildSplits(nodeList, feelist, taxes);
				}
			}
			return feelist;
		}
		private void GetTaxChildSplits(XmlNodeList nodeList, List<Fee> feelist, XmlNode taxes)
		{
			foreach (XmlNode xNode in nodeList)
			{
				var fee = GetTransferTaxSet(taxes, xNode, "Borrower", "BuyerSplit");
				if (fee != null) feelist?.Add(fee);
				fee = GetTransferTaxSet(taxes, xNode, "Seller", "SellerSplit");
				if (fee != null) feelist?.Add(fee);
				fee = GetTransferTaxSet(taxes, xNode, "Lender", "LenderSplit");
				if (fee != null) feelist?.Add(fee);
			}
		}
		private Fee GetTransferTaxSet(XmlNode taxes, XmlNode xNode, string userType, string splitType)
		{
			var fee = new Fee();
			if (taxes != null && xNode != null)
			{
				fee.ReferenceId = "Transfer" + taxes["TaxType"]?.InnerText + xNode["TaxingEntityJurisdiction"]?.InnerText;
				fee.Name = taxes["TaxType"]?.InnerText + " - " + xNode["TaxingEntityJurisdiction"]?.InnerText + "- " + userType;
				fee.LoanEstSection = "E";
				fee.HudLineNum = xNode["TaxingEntityJurisdiction"]?.InnerText == "State" ? "1205" : "1204";
				fee.IncludedInApr = "false";
				fee.Amount = xNode[splitType].InnerText;
				fee.PaidBy = userType;
			}
			return fee;
		}
		#endregion Transfer Tax

		#region Policy
		private List<Fee> GetLenderPolicy(XmlDocument xmlDoc)
		{
			var splitsList = xmlDoc?.SelectNodes("//LendersPolicy/Splits/Split");
			var lenderPolicyList = xmlDoc?.SelectNodes("//LendersPolicy");
			var feelist = new List<Fee>();
			if (lenderPolicyList != null && lenderPolicyList?.Count > 0)
			{
				if (splitsList?.Count > 0)
				{
					foreach (XmlNode splits in splitsList)
					{
						var fee = GetLenderOwnerPolicyDetails(xmlDoc?.SelectSingleNode("//LendersPolicy/Name")?.InnerText, splits, "C", "1104", "LenderPolicy");
						feelist = GetAmounts(splits, feelist, fee);
					}
					if (feelist?.Count <= 0 && splitsList?.Count > 0)
					{
						GetSplitDetails(xmlDoc, feelist, splitsList);
					}
				}
				else
				{
					var fee = GetLenderOwnerPolicyDetails(xmlDoc?.SelectSingleNode("//LendersPolicy/Name")?.InnerText, null, "C", "1104", "LenderPolicy");
					fee.Amount = Convert.ToString(GetLenderFee(xmlDoc));
					feelist.Add(fee);
				}
				return feelist;
			}
			return feelist;
		}
		private void GetSplitDetails(XmlDocument xmlDoc, List<Fee> feeList, XmlNodeList splitsList)
		{
			var fee = GetLenderOwnerPolicyDetails(xmlDoc?.SelectSingleNode("//LendersPolicy/Name")?.InnerText, null, "C", "1104", "LenderPolicy");
			var amount = GetLenderFee(xmlDoc);
			if (amount == 0 && splitsList?.Count > 0)
			{
				fee.Amount = Convert.ToString(amount);
				feeList?.Add(fee);
			}
		}
		private decimal GetLenderFee(XmlDocument xmlDoc)
		{
			var splitAmount = xmlDoc?.SelectSingleNode("//LendersPolicy/Premium")?.InnerText;
			var splitSales = xmlDoc?.SelectSingleNode("//LendersPolicy/SalesTax")?.InnerText;
			var amount = Decimal.Add(decimal.Parse(splitAmount ?? "0.00"), decimal.Parse(splitSales ?? "0.00"));
			return amount;
		}
		private Fee GetLenderOwnerPolicyDetails(string policyName, XmlNode splits, string loanSection, string hudLine, string refID)
		{
			var fee = new Fee();
			fee.Name = policyName;
			fee.LoanEstSection = loanSection;
			fee.ReferenceId = refID;
			fee.IncludedInApr = "false";
			fee.HudLineNum = hudLine;
			if (splits != null)
			{
				if (splits["PaidBy"]?.InnerText?.ToLower() == "buyer")
					fee.PaidBy = "Borrower";
				else if (splits["PaidBy"]?.InnerText?.ToLower() == "seller")
					fee.PaidBy = "Seller";
			}
			else
			{ fee.PaidBy = "Borrower"; }
			return fee;
		}
		private List<Fee> GetOwnerPolicy(XmlDocument xmlDoc)
		{
			var splitsList = xmlDoc?.SelectNodes("//OwnersPolicy/Splits/Split");
			var lenderPolicyList = xmlDoc?.SelectNodes("//OwnersPolicy");
			var feelist = new List<Fee>();
			if (lenderPolicyList != null && lenderPolicyList?.Count > 0)
			{
				if (splitsList?.Count > 0)
				{
					foreach (XmlNode splits in splitsList)
					{

						var fee = GetLenderOwnerPolicyDetails(xmlDoc.SelectSingleNode("//OwnersPolicy/Name")?.InnerText, splits, "H", "1103", "OwnerPolicy");
						feelist = GetAmounts(splits, feelist, fee);
					}
					if ((feelist?.Count <= 0 && splitsList?.Count > 0))
					{
						GetOwnerSplitFee(xmlDoc, splitsList, feelist);
					}
				}
				else
				{
					var fee = GetLenderOwnerPolicyDetails(xmlDoc.SelectSingleNode("//OwnersPolicy/Name")?.InnerText, null, "H", "1103", "OwnerPolicy");
					fee.Amount = Convert.ToString(GetOwnerFee(xmlDoc));
					feelist?.Add(fee);
				}
				return feelist;
			}
			return feelist;
		}
		private void GetOwnerSplitFee(XmlDocument xmlDoc, XmlNodeList splitsList, List<Fee> feelist)
		{
			var fee = GetLenderOwnerPolicyDetails(xmlDoc.SelectSingleNode("//OwnersPolicy/Name")?.InnerText, null, "H", "1103", "OwnerPolicy");
			var amount = GetOwnerFee(xmlDoc);
			if (amount == 0 && splitsList?.Count > 0)
			{
				fee.Amount = Convert.ToString(amount);
				feelist.Add(fee);
			}
		}
		private decimal GetOwnerFee(XmlDocument xmlDoc)
		{
			var splitAmount = xmlDoc.SelectSingleNode("//OwnersPolicy/Premium")?.InnerText;
			var splitSales = xmlDoc.SelectSingleNode("//OwnersPolicy/SalesTax")?.InnerText;
			var amount = Decimal.Add(decimal.Parse(splitAmount ?? "0.00"), decimal.Parse(splitSales ?? "0.00"));
			return amount;
		}
		#endregion Policy

		#region Endrosements
		private List<Fee> GetEndrosements(XmlDocument xmlDoc)
		{
			var endroList = xmlDoc?.SelectNodes("//Endorsements/Endorsement");
			var feelist = new List<Fee>();
			if (endroList != null && endroList.Count > 0)
			{
				foreach (XmlNode endros in endroList)
				{
					var splitList = endros["Splits"]?.ChildNodes;
					if (splitList != null && splitList.Count > 0)
					{
						GetEndorsementFee(splitList, endros, feelist);
					}
					else
					{
						var fee = GetEndrosementsSplits(null, endros);
						fee.Amount = Convert.ToString(GetFee(endros));
						feelist?.Add(fee);
					}
				}
				return feelist;
			}
			return feelist;
		}
		private void GetEndorsementFee(XmlNodeList splitList, XmlNode endros, List<Fee> feelist)
		{
			foreach (XmlNode splits in splitList)
			{
				var fee = GetEndrosementsSplits(splits, endros);
				feelist = GetAmounts(splits, feelist, fee);
			}
			if ((feelist?.Count <= 0 && splitList?.Count > 0))
			{
				var fee = GetEndrosementsSplits(null, endros);
				var amount = GetFee(endros);
				if (amount == 0 && splitList?.Count > 0)
				{
					fee.Amount = Convert.ToString(amount);
					feelist.Add(fee);
				}
			}
		}
		private decimal GetFee(XmlNode xmlNode)
		{
			var splitAmount = xmlNode["Amount"]?.InnerText;
			var splitSales = xmlNode["SalesTax"]?.InnerText;
			var amount = Decimal.Add(decimal.Parse(splitAmount ?? "0.00"), decimal.Parse(splitSales ?? "0.00"));
			return amount;
		}
		private Fee GetEndrosementsSplits(XmlNode splits, XmlNode endros)
		{
			var fee = new Fee();
			fee.ReferenceId = endros["Code"]?.InnerText;
			fee.Name = endros["Name"]?.InnerText;
			fee.LoanEstSection = "C";
			fee.HudLineNum = "1104";
			fee.IncludedInApr = "false";
			if (splits != null)
			{
				if (splits["PaidBy"]?.InnerText?.ToLower() == "buyer")
					fee.PaidBy = "Borrower";
				else if (splits["PaidBy"]?.InnerText?.ToLower() == "seller")
					fee.PaidBy = "Seller";
			}
			else
			{ fee.PaidBy = "Borrower"; }
			return fee;
		}
		#endregion Endrosements

		#region SettlementFees
		private List<Fee> GetSettlementFee(XmlDocument xmlDoc)
		{
			var settlementList = xmlDoc?.SelectNodes("//ItemizedSettlementFees/SettlementFee");
			var feelist = new List<Fee>();
			if (settlementList != null && settlementList.Count > 0)
			{
				foreach (XmlNode settlement in settlementList)
				{
					var splitList = settlement["Splits"]?.ChildNodes;
					if (splitList != null && splitList.Count > 0)
					{
						GetSettlementFee(splitList, feelist, settlement);
					}
					else
					{
						var fee = GetSettlementDetails(null, settlement);
						fee.Amount = Convert.ToString(GetFee(settlement));
						feelist?.Add(fee);
					}
				}
				return feelist;
			}
			return feelist;
		}
		private void GetSettlementFee(XmlNodeList splitList, List<Fee> feelist, XmlNode settlement)
		{
			foreach (XmlNode splits in splitList)
			{
				var fee = GetSettlementDetails(splits, settlement);
				feelist = GetAmounts(splits, feelist, fee);
			}
			if ((feelist?.Count <= 0 && splitList?.Count > 0))
			{
				var fee = GetSettlementDetails(null, settlement);
				var amount = GetFee(settlement);
				if (amount == 0 && splitList?.Count > 0)
				{
					fee.Amount = Convert.ToString(amount);
					feelist?.Add(fee);
				}
			}
		}
		private List<Fee> GetAmounts(XmlNode splits, List<Fee> feelist, Fee fee)
		{
			var splitAmount = splits["Amount"]?.InnerText;
			var splitSales = splits["SalesTax"]?.InnerText;
			var amount = Decimal.Add(decimal.Parse(splitAmount ?? "0.00"), decimal.Parse(splitSales ?? "0.00"));
			if (amount != 0)
			{
				fee.Amount = Convert.ToString(amount);
				feelist?.Add(fee);
			}
			return feelist;
		}
		private Fee GetSettlementDetails(XmlNode splits, XmlNode settlement)
		{
			var fee = new Fee();
			fee.ReferenceId = settlement["Code"]?.InnerText;
			fee.Name = settlement["Name"]?.InnerText;
			fee.LoanEstSection = "C";
			fee.HudLineNum = "1101";
			fee.IncludedInApr = "false";
			if (splits != null)
			{
				if (splits["PaidBy"]?.InnerText?.ToLower() == "buyer")
					fee.PaidBy = "Borrower";
				else if (splits["PaidBy"]?.InnerText?.ToLower() == "seller")
					fee.PaidBy = "Seller";
			}
			else
			{ fee.PaidBy = "Borrower"; }
			return fee;
		}
		#endregion SettlementFees
	}
}
