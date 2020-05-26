Feature: PBI55031TransformRequest
	
@200-Status-OK
Scenario:Status OK
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint '/quote/request'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'

@404-Notfound
Scenario:Invalid Endpoint
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint '/request'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'NotFound'

@401-NotAuthorized
Scenario:Invalid Bearer Toekn
	Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint '/quote/request'
	When User Posted the file without authorization and contentType as 'application/xml'
	Then Status code should be 'Unauthorized'

@400-BadRequest
Scenario:Invalid Content
	Given User has Request File'RequestFiles\InvalidGetFeesForHomeLoanProductRequest.xml'
	And User has Endpoint 'quote/request'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'BadRequest'

Scenario:With Purpose = "Refinance" but appraisedValue & purchasePrice having Value
Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
And User has Endpoint 'quote/request'
When User has modified below  information in the  input file
| Xpath                                                                                 | ValuetoModify            |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                | Refinance                |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/city   | WACity                   |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/county | Adams County Census Area |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/state  | WA                       |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/appraisedValue         | 10000                    |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/purchasePrice          | 20000                    |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/loanAmount             | 300000                   |


When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
 | Xpath                                                 | Expectedvalue |
 | /Request/ErnstRequest/TransactionCode                 | 100           |
 | /Request/ErnstRequest/Property/City                   | WACity        |
 | /Request/ErnstRequest/Property/County                 | Adams         |
 | /Request/ErnstRequest/Property/State                  | WA            |
 | /Request/ErnstRequest/Property/EstimatedValue         | 0.0           |
 | /Request/ErnstRequest/Property/MortgageAmount         | 300000        |
 | /Request/ErnstRequest/NumberOfPages/Deed              | 0             |
 | /Request/ErnstRequest/Deed/AmendmentModificationPages | 0             |
 | /Request/ErnstRequest/Release/Pages                   | 4             |
 | /Request/ErnstRequest/Release/NumberOfReleases        | 1             |

Scenario:With Purpose other than "Refinance" and appraisedValue is greater than purchasePrice
Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
And User has Endpoint 'quote/request'
When User has modified below  information in the  input file
| Xpath                                                                                 | ValuetoModify            |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                | Purchase                 |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/city   | WACity                   |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/county | Adams County Census Area |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/state  | WA                       |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/appraisedValue         | 20000                    |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/purchasePrice          | 10000                    |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/loanAmount             | 300000                   |


When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
  | Xpath                                                     | Expectedvalue |
  | /Request/ErnstRequest/TransactionCode                     | 100           |
  | /Request/ErnstRequest/Property/City                       | WACity        |
  | /Request/ErnstRequest/Property/County                     | Adams         |
  | /Request/ErnstRequest/Property/State                      | WA            |
  | /Request/ErnstRequest/Property/EstimatedValue             | 20000         |
  | /Request/ErnstRequest/Property/MortgageAmount             | 300000        |
  | /Request/ErnstRequest/NumberOfPages/Mortgage              | 30            |
  | /Request/ErnstRequest/Mortgage/AmendmentModificationPages | 0             |
  | /Request/ErnstRequest/NumberOfPages/Deed                  | 3             |
  | /Request/ErnstRequest/Deed/AmendmentModificationPages     | 0             |


Scenario:With Purpose other than "Refinance" and appraisedValue less than purchasePrice
Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
And User has Endpoint 'quote/request'
When User has modified below  information in the  input file
| Xpath                                                                                 | ValuetoModify            |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                | Purchase                 |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/city   | WACity                   |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/county | Adams County Census Area |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/state  | WA                       |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/appraisedValue         | 10000                    |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/purchasePrice          | 20000                    |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/loanAmount             | 300000                   |

When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
  | Xpath                                                     | Expectedvalue |
  | /Request/ErnstRequest/TransactionCode                     | 100           |
  | /Request/ErnstRequest/Property/City                       | WACity        |
  | /Request/ErnstRequest/Property/County                     | Adams         |
  | /Request/ErnstRequest/Property/State                      | WA            |
  | /Request/ErnstRequest/Property/EstimatedValue             | 20000         |
  | /Request/ErnstRequest/Property/MortgageAmount             | 300000        |
  | /Request/ErnstRequest/NumberOfPages/Mortgage              | 30            |
  | /Request/ErnstRequest/Mortgage/AmendmentModificationPages | 0             |
  | /Request/ErnstRequest/NumberOfPages/Deed                  | 3             |
  | /Request/ErnstRequest/Deed/AmendmentModificationPages     | 0             |


Scenario:With Purpose= "MortgageModification"
Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
And User has Endpoint 'quote/request'
When User has modified below  information in the  input file
| Xpath                                                                                 | ValuetoModify        |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                | MortgageModification |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/city   | WACity               |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/county | Adams Census Area    |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/state  | WA                   |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/appraisedValue         | 10000                |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/purchasePrice          | 20000                |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/loanAmount             | 300000               |

When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
  | Xpath                                                     | Expectedvalue |
  | /Request/ErnstRequest/TransactionCode                     | 100           |
  | /Request/ErnstRequest/Property/City                       | WACity        |
  | /Request/ErnstRequest/Property/County                     | Adams         |
  | /Request/ErnstRequest/Property/State                      | WA            |
  | /Request/ErnstRequest/Property/EstimatedValue             | 20000         |
  | /Request/ErnstRequest/Property/MortgageAmount             | 300000        |
  | /Request/ErnstRequest/NumberOfPages/Mortgage              | 0             |
  | /Request/ErnstRequest/Mortgage/AmendmentModificationPages | 30            |
  | /Request/ErnstRequest/NumberOfPages/Deed                  | 0             |
  | /Request/ErnstRequest/Deed/AmendmentModificationPages     | 3             |

Scenario:With Purpose= "Other/Unknown/Purchase"
Given User has Request File'RequestFiles\GetFeesForHomeLoanProductRequest.xml'
And User has Endpoint 'quote/request'
When User has modified below  information in the  input file
| Xpath                                                                                 | ValuetoModify |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/purpose                | Other         |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/city   | WACity        |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/county | Adams Borough |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/propertyAddress/state  | WA            |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/appraisedValue         | 10000         |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/property/purchasePrice          | 20000         |
| /GetFeesForHomeLoanProductRequest/homeLoanApplication/homeLoan/loanAmount             | 300000        |

When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
  | Xpath                                                     | Expectedvalue |
  | /Request/ErnstRequest/TransactionCode                     | 100           |
  | /Request/ErnstRequest/Property/City                       | WACity        |
  | /Request/ErnstRequest/Property/County                     | Adams         |
  | /Request/ErnstRequest/Property/State                      | WA            |
  | /Request/ErnstRequest/Property/EstimatedValue             | 20000         |
  | /Request/ErnstRequest/Property/MortgageAmount             | 300000        |
  | /Request/ErnstRequest/NumberOfPages/Mortgage              | 30            |
  | /Request/ErnstRequest/Mortgage/AmendmentModificationPages | 0             |
  | /Request/ErnstRequest/NumberOfPages/Deed                  | 3             |
  | /Request/ErnstRequest/Deed/AmendmentModificationPages     | 0             |
