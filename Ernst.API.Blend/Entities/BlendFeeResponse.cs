using System.Collections.Generic;
using System.Xml.Serialization;

namespace Ernst.Api.Blend.Entities
{
	public class BlendFeeResponse
    {
        
        [XmlRoot(ElementName = "GetFeesForHomeLoanProductResponse")]
        public class HomeLoanResponse
        {
            [XmlElement(ElementName = "version")]
            public string Version { get; set; }
            [XmlElement(ElementName = "requestId")]
            public string RequestId { get; set; }
            [XmlElement(ElementName = "responseStatus")]
            public string ResponseStatus { get; set; }
            [XmlElement(ElementName = "responseSystemMessage")]
            public string SystemMessage { get; set; }
            [XmlElement(ElementName = "body")]
            public Body Body { get; set; }
        }

        public class Body
        {
            [XmlElement(ElementName = "Fees")]
            public Fees FeeList { get; set; }
        }

        public class Fees
        {
            [XmlElement(ElementName = "Fee")]
            public List<Fee> Fee { get; set; }
        }

        public class Fee
        {
            [XmlElement(ElementName = "referenceId")]
            public string ReferenceId { get; set; }
            [XmlElement(ElementName = "name")]
            public string Name { get; set; }
            [XmlElement(ElementName = "loanEstimateSection")]
            public string LoanEstSection { get; set; }
            [XmlElement(ElementName = "hudLineNumber")]
            public string HudLineNum { get; set; }
            [XmlElement(ElementName = "includedInApr")]
            public string IncludedInApr { get; set; }
            [XmlElement(ElementName = "amount")]
            public string Amount { get; set; }
            [XmlElement(ElementName = "paidBy")]
            public string PaidBy { get; set; }
        }
    }
}
