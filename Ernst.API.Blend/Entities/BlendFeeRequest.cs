using System.Collections.Generic;
using System.Xml.Serialization;
using static Ernst.API.Blend.Utilities.Enumerations;

namespace Ernst.Api.Blend.Entities
{
	[XmlRoot(ElementName = "GetFeesForHomeLoanProductRequest")]
    public class BlendFeeRequest
    {
        [XmlElement(ElementName = "version")]
        public string Version { get; set; }
        [XmlElement(ElementName = "requestId")]
        public string RequestId { get; set; }       
        [XmlElement(ElementName = "homeLoanApplication")]
        public HomeLoanApplication HomeLoanApplication { get; set; }
    }

    [XmlRoot(ElementName = "homeLoanApplication")]
    public class HomeLoanApplication
    {
        [XmlElement(ElementName = "borrowers")]
        public Borrowers Borrowers { get; set; }

        [XmlElement(ElementName = "property")]
        public Property Property { get; set; }

        [XmlElement(ElementName = "homeLoan")]
        public HomeLoan HomeLoan { get; set; }
    }

    [XmlRoot(ElementName = "borrowers")]
    public class Borrowers
    {
        [XmlElement(ElementName = "borrower")]
        public List<Borrower> BorrowerLst { get; set; }
    }

    [XmlRoot(ElementName = "borrower")]
    public class Borrower
    {
        [XmlElement(ElementName = "firstTimeHomeBuyer")]
        public string FirstTimeHomeBuyer { get; set; }
    }

    [XmlRoot(ElementName = "property")]
    public class Property
    {
        [XmlElement(ElementName = "appraisedValue")]
        public string AppraisedValue { get; set; }

        [XmlElement(ElementName = "purchasePrice")]
        public string PurchasePrice { get; set; }

        [XmlElement(ElementName = "propertyType")]
        public string PropertyType { get; set; }
        [XmlElement(ElementName = "propertyUsageType")]
        public string PropertyUsageType { get; set; }
        [XmlElement(ElementName = "numberOfUnits")]
        public string NumberOfUnits { get; set; }    
        
        [XmlElement(ElementName = "propertyAddress")]
        public PropertyAddress PropertyAddress { get; set; }
    }

    [XmlRoot(ElementName = "propertyAddress")]
    public class PropertyAddress
    {
        [XmlElement(ElementName = "city")]
        public string City { get; set; }

        [XmlElement(ElementName = "state")]
        public string State { get; set; }

        [XmlElement(ElementName = "county")]
        public string County { get; set; }

        [XmlElement(ElementName = "postalCode")]
        public string PostalCode { get; set; }
    }

    [XmlRoot(ElementName = "homeLoan")]
    public class HomeLoan
    {
        [XmlElement(ElementName = "product")]
        public Product Product { get; set; }

        [XmlElement(ElementName = "purpose")]
        public string Purpose { get; set; }

        [XmlElement(ElementName = "lienType")]
        public string LienType { get; set; }

        [XmlElement(ElementName = "sameLenderRefinance")]
        public string SameLenderRefinance { get; set; }

        [XmlElement(ElementName = "loanAmount")]
        public string LoanAmount { get; set; }

        [XmlElement(ElementName = "purchasePrice")]
        public string PurchasePrice { get; set; }
    }

    [XmlRoot(ElementName = "product")]
    public class Product
    {
        [XmlElement(ElementName = "amortizationType")]
        public string AmortizationType { get; set; }
    }
}
