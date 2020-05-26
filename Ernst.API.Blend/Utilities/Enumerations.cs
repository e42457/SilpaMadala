namespace Ernst.API.Blend.Utilities
{
	public static class Enumerations
    {
        public enum ProjectLegalStructure
        {
            CommonInterestApartment,
            Condominium,
            Cooperative,
            Condotel,
            MixedUseCondo,
            Unknown
        }

        public enum ResponseStatus
        {
            Success,
            InvalidRequest,
            ServerErrorRetryable,
            ServerErrorFatal,
            NotImplemented
        }

        public enum MismoLoanPurpose 
        {
            MortgageModification,
            Other,
            Purchase,
            Refinance,
            Unknown
        }

        public enum EnumProjectLegalStructure
        {
            Condominium,
            Cooperative,
            Unknown
        }
        public enum EnumLienType
        {
            First,
            Second,
            HELOC,
            Other
        }
    }
}
