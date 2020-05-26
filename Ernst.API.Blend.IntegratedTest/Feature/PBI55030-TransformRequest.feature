Feature: PBI55030TransformRequest

@200-Status-OK
Scenario:Status OK
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'

@404-Notfound
Scenario:Invalid Endpoint
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/resnse'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'NotFound'

@401-NotAuthorized
Scenario:Invalid Bearer Toekn
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User Posted the file without authorization and contentType as 'application/xml'
	Then Status code should be 'Unauthorized'

@400-BadRequest
Scenario:Invalid Content
	Given User has Request File'RequestFiles\InvalidGetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'BadRequest'

Scenario:With lienType not equal to "HELOC" and propertyType = SingleFamily and Purpose other than "Refinance"
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User has modified below  information in the  input file
	 | XPath                                                                                       | ValuetoModify                        |
	 | /GetFeesForHomeLoanProductRequest/requestId                                                 | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/borrowers/borrower/firstTimeHomeBuyer | True                                 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/lienType                     | First                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                      | Purchase                             |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/product/amortizationType     | Fixed                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/sameLenderRefinance          | False                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/numberOfUnits                | 1                                    |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyType                 | SingleFamily                         |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyUsageType            | PrimaryResidence                     |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                               | Expectedvalue                        |
	 | /Request/Version                                    | 3                                    |
	 | /Request/Authentication/UserID                      | SalesDemo                            |
	 | /Request/Authentication/Password                    | Demo123                              |
	 | /Request/TransactionDate                            | CurrentDate                          |
	 | /Request/ClientTransactionID                        | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /Request/RequestInfo/Loan/FirstTimeHomeBuyer        | true                                 |
	 | /Request/RequestInfo/Loan/ApplicationDate           | CurrentDate                          |
	 | /Request/RequestInfo/Loan/HELOC                     | false                                |
	 | /Request/RequestInfo/Loan/LoanPurpose               | Purchase                             |
	 | /Request/RequestInfo/Loan/RefinanceSameLender       | false                                |
	 | /Request/RequestInfo/Property/NumberOfUnits         | 1                                    |
	 | /Request/RequestInfo/Property/ProjectLegalStructure | Unknown                              |
	 | /Request/RequestInfo/Property/PropertyUse           | PrimaryResidence                     |  

Scenario:With lienType equal to "HELOC" and propertyType = SingleFamily and Purpose other than "Refinance"
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User has modified below  information in the  input file
	 | XPath                                                                                       | ValuetoModify                        |
	 | /GetFeesForHomeLoanProductRequest/requestId                                                 | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/borrowers/borrower/firstTimeHomeBuyer | true                                 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/lienType                     | HELOC                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                      | Purchase                             |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/product/amortizationType     | Fixed                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/sameLenderRefinance          | false                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/numberOfUnits                | 1                                    |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyType                 | SingleFamily                         |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyUsageType            | PrimaryResidence                     |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                               | Expectedvalue                        |
	 | /Request/Version                                    | 3                                    |
	 | /Request/Authentication/UserID                      | SalesDemo                            |
	 | /Request/Authentication/Password                    | Demo123                              |
	 | /Request/TransactionDate                            | CurrentDate                          |
	 | /Request/ClientTransactionID                        | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /Request/RequestInfo/Loan/FirstTimeHomeBuyer        | true                                 |
	 | /Request/RequestInfo/Loan/ApplicationDate           | CurrentDate                          |
	 | /Request/RequestInfo/Loan/HELOC                     | true                                 |
	 | /Request/RequestInfo/Loan/LoanPurpose               | Purchase                             |
	 | /Request/RequestInfo/Loan/RefinanceSameLender       | false                                |
	 | /Request/RequestInfo/Property/NumberOfUnits         | 1                                    |
	 | /Request/RequestInfo/Property/ProjectLegalStructure | Unknown                              |
	 | /Request/RequestInfo/Property/PropertyUse           | PrimaryResidence                     |  

Scenario:With lienType equal to "HELOC" and propertyType = "Condominium" and Purpose other than "Refinance"
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User has modified below  information in the  input file
	 | XPath                                                                                       | ValuetoModify                        |
	 | /GetFeesForHomeLoanProductRequest/requestId                                                 | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/borrowers/borrower/firstTimeHomeBuyer | true                                 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/lienType                     | HELOC                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                      | Purchase                             |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/product/amortizationType     | Fixed                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/sameLenderRefinance          | false                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/numberOfUnits                | 1                                    |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyType                 | Condominium                          |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyUsageType            | PrimaryResidence                     |   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                               | Expectedvalue                        |
	 | /Request/Version                                    | 3                                    |
	 | /Request/Authentication/UserID                      | SalesDemo                            |
	 | /Request/Authentication/Password                    | Demo123                              |
	 | /Request/TransactionDate                            | CurrentDate                          |
	 | /Request/ClientTransactionID                        | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /Request/RequestInfo/Loan/FirstTimeHomeBuyer        | true                                 |
	 | /Request/RequestInfo/Loan/ApplicationDate           | CurrentDate                          |
	 | /Request/RequestInfo/Loan/HELOC                     | true                                 |
	 | /Request/RequestInfo/Loan/LoanPurpose               | Purchase                             |
	 | /Request/RequestInfo/Loan/RefinanceSameLender       | false                                |
	 | /Request/RequestInfo/Property/NumberOfUnits         | 1                                    |
	 | /Request/RequestInfo/Property/ProjectLegalStructure | Condominium                          |
	 | /Request/RequestInfo/Property/PropertyUse           | PrimaryResidence                     |   

Scenario:With lienType equal to "HELOC" and propertyType = "Cooperative" and Purpose other than "Refinance"
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User has modified below  information in the  input file
	 | XPath                                                                                       | ValuetoModify                        |
	 | /GetFeesForHomeLoanProductRequest/requestId                                                 | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/borrowers/borrower/firstTimeHomeBuyer | True                                 |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/lienType                     | HELOC                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                      | Purchase                             |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/product/amortizationType     | Fixed                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/sameLenderRefinance          | False                                |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/numberOfUnits                | 1                                    |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyType                 | cooperative                          |
	 | /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyUsageType            | PrimaryResidence                     |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                               | Expectedvalue                        |
	 | /Request/Version                                    | 3                                    |
	 | /Request/Authentication/UserID                      | SalesDemo                            |
	 | /Request/Authentication/Password                    | Demo123                              |
	 | /Request/TransactionDate                            | CurrentDate                          |
	 | /Request/ClientTransactionID                        | 502eebbb-b930-4634-bb69-e0e583cc9748 |
	 | /Request/RequestInfo/Loan/FirstTimeHomeBuyer        | true                                 |
	 | /Request/RequestInfo/Loan/ApplicationDate           | CurrentDate                          |
	 | /Request/RequestInfo/Loan/HELOC                     | true                                 |
	 | /Request/RequestInfo/Loan/LoanPurpose               | Purchase                             |
	 | /Request/RequestInfo/Loan/RefinanceSameLender       | false                                |
	 | /Request/RequestInfo/Property/NumberOfUnits         | 1                                    |
	 | /Request/RequestInfo/Property/ProjectLegalStructure | Cooperative                          |
	 | /Request/RequestInfo/Property/PropertyUse           | PrimaryResidence                     |   
