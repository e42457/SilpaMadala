using System;
using System.Xml.Serialization;

namespace Ernst.Api.Blend.Entities
{
	[XmlRoot(ElementName = "Request")]
    public partial class ErnstFeeRequest
    {
        [XmlElement(ElementName = "Version")]
        public decimal Version { get; set; }
        [XmlElement(ElementName = "TransactionDate")]
        public DateTime TransactionDate { get; set; }
        [XmlElement(ElementName = "ClientTransactionID")]
        public string ClientTransactionID { get; set; }
        [XmlElement(ElementName = "Authentication")]
        public Authentication Authentication { get; set; }
        [XmlElement(ElementName = "RequestInfo")]
        public RequestInfo RequestInfo { get; set; }

        [XmlElement(ElementName = "ErnstRequest")]
        public ErnstRequest ErnstRequest { get; set; }

        [XmlElement(ElementName = "TitleRequest")]
        public TitleRequest TitleRequest { get; set; }
    }

    [XmlRoot(ElementName = "Authentication")]
    public class Authentication
    {
        [XmlElement(ElementName = "UserID")]
        public string UserID { get; set; }
        [XmlElement(ElementName = "Password")]
        public string Password { get; set; }
    }

    [XmlRoot(ElementName = "RequestInfo")]
    public class RequestInfo
    {
        [XmlElement(ElementName = "Loan")]
        public Loan Loan { get; set; }
        [XmlElement(ElementName = "Property")]
        public ErnstProperty Property { get; set; }
    }

    [XmlRoot(ElementName = "Loan")]
    public class Loan
    {
        [XmlElement(ElementName = "ApplicationDate")]
        public DateTime? ApplicationDate { get; set; }

        [XmlElement(ElementName = "FirstTimeHomeBuyer")]
        public bool? FirstTimeHomeBuyer { get; set; }

        [XmlElement(ElementName = "HELOC")]
        public bool HELOC { get; set; }

        [XmlElement(ElementName = "LoanPurpose")]
        public string LoanPurpose { get; set; }                     

        [XmlElement(ElementName = "RateType")]
        public string RateType { get; set; } 

        [XmlElement(ElementName = "RefinanceSameLender")]
        public bool? RefinanceSameLender { get; set; }

    }

    [XmlRoot(ElementName = "Property")]
    public class ErnstProperty
    {
        [XmlElement(ElementName = "NumberOfUnits")]
        public string NumberOfUnits { get; set; }

        [XmlElement(ElementName = "ProjectLegalStructure")]
        public string ProjectLegalStructure { get; set; } 

        [XmlElement(ElementName = "PropertyUse")]
        public string PropertyUse { get; set; } 
    }

    [XmlRoot(ElementName = "ErnstRequest")]
    public class ErnstRequest
    {
        [XmlElement(ElementName = "Version")]
        public string Version { get; set; }

        [XmlElement(ElementName = "TransactionCode")]
        public string TransactionCode { get; set; }

        [XmlElement(ElementName = "Property")]
        public ErnstRequestProperty Property { get; set; }

        [XmlElement(ElementName = "NumberOfPages")]
        public NumberOfPages NumberOfPages { get; set; }

        [XmlElement(ElementName = "Mortgage")]
        public Mortgage Mortgage { get; set; }

        [XmlElement(ElementName = "Deed")]
        public Deed Deed { get; set; }

        [XmlElement(ElementName = "Release")]
        public Release Release { get; set; }
    }

    [XmlRoot(ElementName = "Property")]
    public class ErnstRequestProperty
    {
        [XmlElement(ElementName = "City")]
        public string City { get; set; }

        [XmlElement(ElementName = "County")]
        public string County { get; set; }

        [XmlElement(ElementName = "State")]
        public string State { get; set; }

        [XmlElement(ElementName = "EstimatedValue")]
        public string EstimatedValue { get; set; }

        [XmlElement(ElementName = "MortgageAmount")]
        public string MortgageAmount { get; set; }
    }

    [XmlRoot(ElementName = "NumberOfPages")]
    public class NumberOfPages
    {
        [XmlElement(ElementName = "Mortgage")]
        public string Mortgage { get; set; }

        [XmlElement(ElementName = "Deed")]
        public string Deed { get; set; }
    }

    [XmlRoot(ElementName = "Mortgage")]
    public class Mortgage
    {
        [XmlElement(ElementName = "AmendmentModificationPages")]
        public string AmendmentModificationPages { get; set; }
    }

    [XmlRoot(ElementName = "Deed")]
    public class Deed
    {
        [XmlElement(ElementName = "AmendmentModificationPages")]
        public string AmendmentModificationPages { get; set; }
    }

    [XmlRoot(ElementName = "Release")]
    public class Release
    {
        [XmlElement(ElementName = "Pages")]
        public string Pages { get; set; }

        [XmlElement(ElementName = "NumberOfReleases")]
        public string NumberOfReleases { get; set; }
    }

    [XmlRoot(ElementName = "TitleRequest")]
    public class TitleRequest
    {
        [XmlElement(ElementName = "Version")]
        public string Version { get; set; }

        [XmlElement(ElementName = "Property")]
        public TitleRequestProperty Property { get; set; }

        [XmlElement(ElementName = "LendersPolicy")]
        public LendersPolicy LendersPolicy { get; set; }

        [XmlElement(ElementName = "OwnersPolicy")]
        public OwnersPolicy OwnersPolicy { get; set; }

        [XmlElement(ElementName = "ItemizedSettlementFees")]
        public ItemizedSettlementFees ItemizedSettlementFees { get; set; }

        [XmlElement(ElementName = "UseCommonEndorsements")]
        public string UseCommonEndorsements { get; set; }

        [XmlElement(ElementName = "UseSimultaneousRates")]
        public string UseSimultaneousRates { get; set; }
    }

    [XmlRoot(ElementName = "Property")]
    public class TitleRequestProperty
    {
        [XmlElement(ElementName = "City")]
        public string City { get; set; }

        [XmlElement(ElementName = "County")]
        public string County { get; set; }

        [XmlElement(ElementName = "State")]
        public string State { get; set; }

        [XmlElement(ElementName = "Zip")]
        public string Zip { get; set; }

        [XmlElement(ElementName = "LoanType")]
        public string LoanType { get; set; }

        [XmlElement(ElementName = "PolicyType")]
        public string PolicyType { get; set; }
    }

    [XmlRoot(ElementName = "LendersPolicy")]
    public class LendersPolicy
    {
        [XmlElement(ElementName = "Requested")]
        public string Requested { get; set; }

        [XmlElement(ElementName = "PolicyAmount")]
        public string PolicyAmount { get; set; }
    }

    [XmlRoot(ElementName = "OwnersPolicy")]
    public class OwnersPolicy
    {
        [XmlElement(ElementName = "Requested")]
        public string Requested { get; set; }

        [XmlElement(ElementName = "PolicyAmount")]
        public string PolicyAmount { get; set; }
    }

    [XmlRoot(ElementName = "ItemizedSettlementFees")]
    public class ItemizedSettlementFees
    {
        [XmlElement(ElementName = "Requested")]
        public string Requested { get; set; }
    }
}
