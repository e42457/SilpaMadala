Feature: PBI55035-TransformTitle


Scenario:With Lender Policy All Values
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                        | ValuetoModify                  |
	 | /Response/TitleResponse/LendersPolicy/Premium                                | 20                             |
	 | /Response/TitleResponse/LendersPolicy/SalesTax                               | 30                             |
	 | /Response/TitleResponse/LendersPolicy/Name                                   | ALTAExtendedCoverageLoanPolicy |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/Amount    | 20                             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax  | 10                             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 40                             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 50                             |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                               | Expectedvalue                  |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/referenceId         | LenderPolicy                   |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/name                | ALTAExtendedCoverageLoanPolicy |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/loanEstimateSection | C                              |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/hudLineNumber       | 1104                           |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/includedInApr       | false                          |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/paidBy              | Borrower                       |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount              | 30                             |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/referenceId           | LenderPolicy                   |  
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/name                  | ALTAExtendedCoverageLoanPolicy |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/loanEstimateSection   | C                              |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/hudLineNumber         | 1104                           |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/includedInApr         | false                          |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/paidBy                | Seller                         |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/amount                | 90                             |  

Scenario:With Lender Policy Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/Amount   | 100           |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax | 150           |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                  | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount | 250           |  

Scenario:Zero Lender Policy Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Premium                               | 20            |
	 | /Response/TitleResponse/LendersPolicy/SalesTax                              | 30            |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/Amount   | 0             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                  | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount | DoesnotExists |  

Scenario:Removed Lender Policy Buyer Split 
	Given User has Request File'RequestFiles\MissingBuyerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                        | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Premium                                | 20            |
	 | /Response/TitleResponse/LendersPolicy/SalesTax                               | 30            |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 100           |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 120           |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                  | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount | DoesnotExists |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/amount   | 220           |  

Scenario:With Lender Policy Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                        | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 100           |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 150           |  

	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']/amount | 250           |  

Scenario:Removed Lender Policy Seller Split 
	Given User has Request File'RequestFiles\MissingSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Premium                               | 250           |
	 | /Response/TitleResponse/LendersPolicy/SalesTax                              | 300           |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/Amount   | 600           |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax | 300           |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                  | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount | 900           |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller']          | DoesnotExists |  

Scenario:Zero Lender Policy Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                        | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Premium                                | 250           |
	 | /Response/TitleResponse/LendersPolicy/SalesTax                               | 300           |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                         | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Seller'] | DoesnotExists |

Scenario:Removed Lender Policy Buyer and Seller Split 
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                          | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Premium  | -450.00       |
	 | /Response/TitleResponse/LendersPolicy/SalesTax | 300.00        |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                  | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount | -150.00       |  

Scenario:Zero Lender Policy Buyer and Seller Split with premium is zero 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                        | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Premium                                | 0.00          |
	 | /Response/TitleResponse/LendersPolicy/SalesTax                               | 0.00          |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 0             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/Amount    | 0             |
	 | /Response/TitleResponse/LendersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax  | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                  | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount | 0.00          |    

Scenario:Removed Lender Policy Buyer and Seller Split with premium amount zero
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                          | ValuetoModify |
	 | /Response/TitleResponse/LendersPolicy/Premium  | 0             |
	 | /Response/TitleResponse/LendersPolicy/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                  | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='LenderPolicy'][paidBy='Borrower']/amount | 0             |   
	     




  Scenario:With Owner Policy All Values
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify                  |
	 | /Response/TitleResponse/OwnersPolicy/Premium                                | 20                             |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax                               | 30                             |
	 | /Response/TitleResponse/OwnersPolicy/Name                                   | ALTAExtendedCoverageLoanPolicy |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/Amount    | 20                             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax  | 10                             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 40                             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 50                             |   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                              | Expectedvalue                  |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/referenceId         | OwnerPolicy                    |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/name                | ALTAExtendedCoverageLoanPolicy |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/loanEstimateSection | H                              |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/hudLineNumber       | 1103                           |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/includedInApr       | false                          |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/paidBy              | Borrower                       |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount              | 30                             |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/referenceId           | OwnerPolicy                    |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/name                  | ALTAExtendedCoverageLoanPolicy |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/loanEstimateSection   | H                              |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/hudLineNumber         | 1103                           |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/includedInApr         | false                          |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/paidBy                | Seller                         |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/amount                | 90                             |  

Scenario:With Owner Policy Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                      | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/Amount   | 100           |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax | 150           |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                 | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount | 250           |  

Scenario:Zero Owner Policy Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                      | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Premium                               | 20            |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax                              | 30            |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/Amount   | 0             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                 | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount | DoesnotExists |  

Scenario:Removed Owner Policy Buyer Split 
	Given User has Request File'RequestFiles\MissingBuyerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Premium                                | 20            |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax                               | 30            |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 22.36         |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 100.65        |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                 | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount | DoesnotExists |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/amount   | 123.01        |  

Scenario:With Owner Policy Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 100           |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 150           |  

	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                               | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/amount | 250           |  

Scenario:Removed Owner Policy Seller Split 
	Given User has Request File'RequestFiles\MissingSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                      | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Premium                               | 250           |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax                              | 300           |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/Amount   | 100           |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax | 25            |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                 | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/amount   | DoesnotExists |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount | 125           |  

Scenario:Zero Owner Policy Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Premium                                | 250           |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax                               | 300           |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                               | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Seller']/amount | DoesnotExists |  

Scenario:Removed Owner Policy Buyer and Seller Split 
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                         | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Premium  | 250           |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax | 300           |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                 | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount | 550           |  

Scenario:Zero Owner Policy Buyer and Seller Split with premium is zero 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                       | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Premium                                | 0.00          |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax                               | 0.00          |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Seller']/SalesTax | 0             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/Amount    | 0             |
	 | /Response/TitleResponse/OwnersPolicy/Splits/Split[PaidBy='Buyer']/SalesTax  | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                 | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount | 0.00          |     

Scenario:Removed Lender Owner Buyer and Seller Split with premium amount zero
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                         | ValuetoModify |
	 | /Response/TitleResponse/OwnersPolicy/Premium  | 0             |
	 | /Response/TitleResponse/OwnersPolicy/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                 | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='OwnerPolicy'][paidBy='Borrower']/amount | 0             |  
	   


 
  Scenario:With SettlementFee All Values
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                               | ValuetoModify               |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Code                                   | TitleAttorneyDocPrepFee     |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount                                 | 20                          |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax                               | 30                          |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Name                                   | Title Attorney Doc Prep Fee |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/Amount    | 20                          |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/SalesTax  | 10.39                       |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/Amount   | 40.00                       |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/SalesTax | 110.00                      |   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                                          | Expectedvalue               |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/referenceId         | TitleAttorneyDocPrepFee     |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/name                | Title Attorney Doc Prep Fee |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/loanEstimateSection | C                           |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/hudLineNumber       | 1101                        |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/includedInApr       | false                       |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/paidBy              | Borrower                    |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount              | 30.39                       |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/referenceId           | TitleAttorneyDocPrepFee     |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/name                  | Title Attorney Doc Prep Fee |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/loanEstimateSection   | C                           |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/hudLineNumber         | 1101                        |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/includedInApr         | false                       |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/paidBy                | Seller                      |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/amount                | 150.00                      |  

Scenario:With SettlementFee Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                              | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/Amount   | 100.33        |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/SalesTax | 150.20        |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount | 250.53        |   

Scenario:Zero SettlementFee Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                      | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount                                | 20            |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax                              | 30            |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/Amount   | 0             |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount | DoesnotExists |  

Scenario:Removed SettlementFee Buyer Split 
	Given User has Request File'RequestFiles\MissingBuyerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                               | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount                                 | 20            |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax                               | 30            |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/Amount   | 3000          |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/SalesTax | 4000          |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount | DoesnotExists |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/amount   | 7000          |  

Scenario:With SettlementFee Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                               | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/Amount   | 100           |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/SalesTax | 150           |  

	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                           | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/amount | 250           |   

Scenario:Removed SettlementFee Seller Split 
	Given User has Request File'RequestFiles\MissingSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                              | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount                                | 250           |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax                              | 300           |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/Amount   | 120           |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/SalesTax | 240           |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/amount   | DoesnotExists |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount | 360           |  

Scenario:Zero SettlementFee Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                               | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount                                 | 250           |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax                               | 300           |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                           | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Seller']/amount | DoesnotExists |   

Scenario:Removed SettlementFee Buyer and Seller Split 
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                              | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount                                | 250           |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax                              | 300           |
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount | 550           |  

Scenario:Zero SettlementFee Buyer and Seller Split with premium is zero 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                                               | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount                                 | 0.00          |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax                               | 0.00          |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/Amount    | 0             |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Buyer']/SalesTax  | 0             |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Splits/Split[PaidBy='Seller']/SalesTax | 0             |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount | 0.00          |    

Scenario:Removed SettlementFee Buyer and Seller Split with premium amount zero
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                 | ValuetoModify |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/Amount   | 0             |
	 | /Response/TitleResponse/ItemizedSettlementFees/SettlementFee[Code='TitleAttorneyDocPrepFee']/SalesTax | 0             |  	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='TitleAttorneyDocPrepFee'][paidBy='Borrower']/amount | 0             |  




  Scenario:With Endorsements All Values
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                   | ValuetoModify                             |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Code                                   | 0000949                                   |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount                                 | 20                                        |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax                               | 30                                        |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Name                                   | TIRSA Waiver of Arbitration (Loan Policy) |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/Amount    | 20                                        |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/SalesTax  | 10.39                                     |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/Amount   | 40.00                                     |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/SalesTax | 110.00                                    |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                                          | Expectedvalue                             |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/referenceId         | 0000949                                   |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/name                | TIRSA Waiver of Arbitration (Loan Policy) |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/loanEstimateSection | C                                         |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/hudLineNumber       | 1104                                      |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/includedInApr       | false                                     |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/paidBy              | Borrower                                  |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount              | 30.39                                     |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/referenceId           | 0000949                                   |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/name                  | TIRSA Waiver of Arbitration (Loan Policy) |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/loanEstimateSection   | C                                         |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/hudLineNumber         | 1104                                      |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/includedInApr         | false                                     |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/paidBy                | Seller                                    |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/amount                | 150.00                                    |      

Scenario:With Endorsements Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                  | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/Amount   | 100.33        |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/SalesTax | 150.20        |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount | 250.53        |  

Scenario:Zero Endorsements Buyer Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                      | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount                                | 20            |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax                              | 30            |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/Amount   | 0             |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount | DoesnotExists |  

Scenario:Removed Endorsements Buyer Split 
	Given User has Request File'RequestFiles\MissingBuyerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                   | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount                                 | 20            |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax                               | 30            |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/Amount   | 3000          |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/SalesTax | 4000          |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount | DoesnotExists |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/amount   | 7000          |  

Scenario:With Endorsements Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                   | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/Amount   | 100           |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/SalesTax | 150           |   

	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                           | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/amount | 250           |  

Scenario:Removed Endorsements Seller Split 
	Given User has Request File'RequestFiles\MissingSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                  | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount                                | 250           |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax                              | 300           |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/Amount   | 120           |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/SalesTax | 240           |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/amount   | DoesnotExists |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount | 360           |  

Scenario:Zero Endorsements Seller Split 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                   | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount                                 | 250           |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax                               | 300           |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/SalesTax | 0             |  
	   
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                           | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Seller']/amount | DoesnotExists |  

Scenario:Removed Endorsements Buyer and Seller Split 
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                     | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount   | 250           |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax | 300           |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount | 550           |  

Scenario:Zero Endorsements Buyer and Seller Split with premium is zero 
	Given User has Request File'RequestFiles\ErnstFeeserviceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                                                   | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount                                 | 0.00          |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax                               | 0.00          |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/Amount   | 0             |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Seller']/SalesTax | 0             |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/Amount    | 0             |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Splits/Split[PaidBy='Buyer']/SalesTax  | 0             |  
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount | 0.00          |  

Scenario:Removed Endorsements Buyer and Seller Split with premium amount zero
	Given User has Request File'RequestFiles\MissingBuyerSellerErnstFeeServiceResponse.xml'
	And User has Endpoint 'quote/response'
	When User has modified below  information in the  input file
	 | XPath                                                                     | ValuetoModify |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/Amount   | 0             |
	 | /Response/TitleResponse/Endorsements/Endorsement[Code='0000949']/SalesTax | 0             |     
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	 | XPath                                                                                             | Expectedvalue |
	 | /GetFeesForHomeLoanProductResponse/body/Fees/Fee[referenceId='0000949'][paidBy='Borrower']/amount | 0             |  
	      