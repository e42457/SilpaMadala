Feature: PBI55034-RecordingElements
	
@200-Status-OK
Scenario:Status OK
	Given User has Request File'RequestFiles\RecordingFees.xml'
	And User has Endpoint 'quote/response'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
@404-Notfound
Scenario:Invalid Endpoint
	Given User has Request File'RequestFiles\RecordingFees.xml'
	And User has Endpoint 'quote/resnse'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'NotFound'
@401-NotAuthorized
Scenario:Invalid Bearer Toekn
	Given User has Request File'RequestFiles\RecordingFees.xml'
	And User has Endpoint 'quote/response'
	When User Posted the file without authorization and contentType as 'application/xml'
	Then Status code should be 'Unauthorized'
@400-BadRequest
Scenario:Invalid Content
	Given User has Request File'RequestFiles\InvalidErnstFeeServiceResponse-Errors.xml'
	And User has Endpoint 'quote/response'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'BadRequest'

Scenario:With LineDescription as Deed  
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file
| Xpath                                                                                         | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Deed2010/LineDescription | deed $        |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Deed2010/Amount          | 405.00        |
When User Posted the file with contentType as 'application/xml' 
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                             | Expectedvalue |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingDeed']/referenceId         | RecordingDeed |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingDeed']/name                | deed $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingDeed']/loanEstimateSection | E             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingDeed']/hudLineNumber       | 1202          |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingDeed']/includedInApr       | false         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingDeed']/amount              | 405.00        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingDeed']/paidBy              | Borrower      |  
Scenario:With LineDescription as Morgage 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file
| Xpath                                                                                             | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Mortgage2010/LineDescription | Mortgage $    |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Mortgage2010/Amount          | 695.00        |
When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                                 | Expectedvalue     |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingMortgage']/referenceId         | RecordingMortgage |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingMortgage']/name                | Mortgage $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingMortgage']/loanEstimateSection | E                 |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingMortgage']/hudLineNumber       | 1202              |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingMortgage']/includedInApr       | false             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingMortgage']/amount              | 695.00            |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingMortgage']/paidBy              | Borrower          |  

Scenario:With LineDescription as Release 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                            | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Release2010/LineDescription | Release $     |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Release2010/Amount          | 550.50        |
  
When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                                | Expectedvalue    |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingRelease']/referenceId         | RecordingRelease |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingRelease']/name                | Release $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingRelease']/loanEstimateSection | E                |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingRelease']/hudLineNumber       | 1202             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingRelease']/includedInApr       | false            |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingRelease']/amount              | 550.50           |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingRelease']/paidBy              | Borrower         |  

Scenario:With LineDescription as Assignment 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                               | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Assignment2010/LineDescription | Assignment $  |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Assignment2010/Amount          | 560.50        |
When User Posted the file with contentType as 'application/xml' 
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                                   | Expectedvalue       |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingAssignment']/referenceId         | RecordingAssignment |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingAssignment']/name                | Assignment $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingAssignment']/loanEstimateSection | E                   |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingAssignment']/hudLineNumber       | 1202                |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingAssignment']/includedInApr       | false               |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingAssignment']/amount              | 560.50              |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingAssignment']/paidBy              | Borrower            |  

Scenario:With LineDescription as POA 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                        | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/POA2010/LineDescription | POA $         |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/POA2010/Amount          | 250.00        |
When User Posted the file with contentType as 'application/xml' 
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                            | Expectedvalue |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingPOA']/referenceId         | RecordingPOA  |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingPOA']/name                | POA $         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingPOA']/loanEstimateSection | E             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingPOA']/hudLineNumber       | 1202          |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingPOA']/includedInApr       | false         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingPOA']/amount              | 250.00        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingPOA']/paidBy              | Borrower      |  

Scenario:With LineDescription as Subordination 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                                  | ValuetoModify   |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Subordination2010/LineDescription | Subordination $ |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Subordination2010/Amount          | 570.00          |
When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                                      | Expectedvalue          |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingSubordination']/referenceId         | RecordingSubordination |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingSubordination']/name                | Subordination $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingSubordination']/loanEstimateSection | E                      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingSubordination']/hudLineNumber       | 1202                   |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingSubordination']/includedInApr       | false                  |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingSubordination']/amount              | 570.00                 |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingSubordination']/paidBy              | Borrower               |  

Scenario:With LineDescription as Notorial 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                             | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Notorial2010/LineDescription | Notorial $    |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Notorial2010/Amount          | 580.00        |
When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                                 | Expectedvalue     |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingNotorial']/referenceId         | RecordingNotorial |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingNotorial']/name                | Notorial $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingNotorial']/loanEstimateSection | E                 |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingNotorial']/hudLineNumber       | 1202              |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingNotorial']/includedInApr       | false             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingNotorial']/amount              | 580.00            |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingNotorial']/paidBy              | Borrower          |  

Scenario:With LineDescription as  ResidentialMortgage 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                                        | ValuetoModify         |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/ResidentialMortgage2010/LineDescription | ResidentialMortgage $ |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/ResidentialMortgage2010/Amount          | 590.00                |
When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                                            | Expectedvalue                |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingResidentialMortgage']/referenceId         | RecordingResidentialMortgage |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingResidentialMortgage']/name                | ResidentialMortgage $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingResidentialMortgage']/loanEstimateSection | E                            |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingResidentialMortgage']/hudLineNumber       | 1202                         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingResidentialMortgage']/includedInApr       | false                        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingResidentialMortgage']/amount              | 590.00                       |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingResidentialMortgage']/paidBy              | Borrower                     |  

Scenario:With LineDescription as  Other 
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                          | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Other2010/LineDescription | Other $       |
| /Response/ErnstResponse/Display/Calculation/HUDRESPA2010/HUDLine1202/Other2010/Amount          | 600.00        |

When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values
| XPath                                                                                              | Expectedvalue  |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingOther']/referenceId         | RecordingOther |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingOther']/name                | Other $        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingOther']/loanEstimateSection | E              |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingOther']/hudLineNumber       | 1202           |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingOther']/includedInApr       | false          |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingOther']/amount              | 600.00         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='RecordingOther']/paidBy              | Borrower       |  

Scenario:With Transfer Taxes - Buyer,seller,lender with TaxingEntityJurisdiction as State.  
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                                             | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxType                                              | MortgageTax   |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/TaxingEntityJurisdiction | State         |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/BuyerSplit               | 6370.00       |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/SellerSplit              | 3000.00       |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/LenderSplit              | 2000.00       |

When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values

| XPath                                                                                                                         | Expectedvalue                 |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - State- Borrower']/referenceId         | TransferMortgageTaxState      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - State- Borrower']/name                | MortgageTax - State- Borrower |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - State- Borrower']/loanEstimateSection | E                             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - State- Borrower']/hudLineNumber       | 1205                          |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - State- Borrower']/includedInApr       | false                         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - State- Borrower']/amount              | 6370.00                       |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - State- Borrower']/paidBy              | Borrower                      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - State- Seller']/referenceId             | TransferMortgageTaxState      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - State- Seller']/name                    | MortgageTax - State- Seller   |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - State- Seller']/loanEstimateSection     | E                             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - State- Seller']/hudLineNumber           | 1205                          |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - State- Seller']/includedInApr           | false                         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - State- Seller']/amount                  | 3000.00                       |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - State- Seller']/paidBy                  | Seller                        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - State- Lender']/referenceId             | TransferMortgageTaxState      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - State- Lender']/name                    | MortgageTax - State- Lender   |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - State- Lender']/loanEstimateSection     | E                             |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - State- Lender']/hudLineNumber           | 1205                          |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - State- Lender']/includedInApr           | false                         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - State- Lender']/amount                  | 2000.00                       |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - State- Lender']/paidBy                  | Lender                        |   

Scenario:With Transfer Taxes - Buyer,seller,lender with TaxingEntityJurisdiction as City
Given User has Request File'RequestFiles\RecordingFees.xml'
And User has Endpoint 'quote/response'
When User has modified below  information in the  input file

| Xpath                                                                                                             | ValuetoModify |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxType                                              | MortgageTax   |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/TaxingEntityJurisdiction | City          |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/BuyerSplit               | 5698.00       |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/SellerSplit              | 6000.00       |
| /Response/ErnstResponse/Display/Calculation/CFPB2015/CFPBTax/TaxingEntities/TaxingEntity/LenderSplit              | 2020.00       |

When User Posted the file with contentType as 'application/xml'
Then Status code should be 'OK'
And Verify Xml Response Values

| XPath                                                                                                                        | Expectedvalue                |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - City- Borrower']/referenceId         | TransferMortgageTaxCity      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - City- Borrower']/name                | MortgageTax - City- Borrower |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - City- Borrower']/loanEstimateSection | E                            |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - City- Borrower']/hudLineNumber       | 1204                         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - City- Borrower']/includedInApr       | false                        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - City- Borrower']/amount              | 5698.00                      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Borrower'][name='MortgageTax - City- Borrower']/paidBy              | Borrower                     |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - City- Seller']/referenceId             | TransferMortgageTaxCity      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - City- Seller']/name                    | MortgageTax - City- Seller   |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - City- Seller']/loanEstimateSection     | E                            |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - City- Seller']/hudLineNumber           | 1204                         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - City- Seller']/includedInApr           | false                        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - City- Seller']/amount                  | 6000.00                      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Seller'][name='MortgageTax - City- Seller']/paidBy                  | Seller                       |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - City- Lender']/referenceId             | TransferMortgageTaxCity      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - City- Lender']/name                    | MortgageTax - City- Lender   |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - City- Lender']/loanEstimateSection     | E                            |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - City- Lender']/hudLineNumber           | 1204                         |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - City- Lender']/includedInApr           | false                        |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - City- Lender']/amount                  | 2020.00                      |
| /GetFeesForHomeLoanProductResponse/body/Fees/Fee[paidBy='Lender'][name='MortgageTax - City- Lender']/paidBy                  | Lender                       |  
