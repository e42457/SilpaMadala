Feature: PBI55033-TransformResponse 
	

Scenario Outline:With valid Data
	Given User has Request File'RequestFiles\ErnstFeeServiceResponse-Errors.xml'
	And User has Endpoint 'quote/response'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'OK'
	And Verify Xml Response Values
	| XPath                                                    | Expectedvalue                                                                                                                                 |
	| /GetFeesForHomeLoanProductResponse/version               | 1                                                                                                                                             |
	| /GetFeesForHomeLoanProductResponse/requestId             | 96583                                                                                                                                         |
	| /GetFeesForHomeLoanProductResponse/responseStatus        | ServerErrorFatal                                                                                                                              |
	| /GetFeesForHomeLoanProductResponse/responseSystemMessage | [1422] Missing State, County and/or Page \| [0030310] Call (Itemized Settlement Fees) Error: Timeout calling Stewart itemized settlement fees |  

Scenario Outline:Post with InvalidData
	Given User has Request File'RequestFiles\InvalidErnstFeeServiceResponse-Errors.xml'
	And User has Endpoint 'quote/response'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'BadRequest'

Scenario Outline:Post Data with InvalidUrl
	Given User has Request File'RequestFiles\ErnstFeeServiceResponse-Errors.xml'
	And User has Endpoint 'quote/resse'
	When User Posted the file with contentType as 'application/xml'
	Then Status code should be 'NotFound'

Scenario Outline:Not Authorized
	Given User has Request File'RequestFiles\ErnstFeeServiceResponse-Errors.xml'
	And User has Endpoint 'quote/response'
	When User Posted the file without authorization and contentType as 'application/xml'
	Then Status code should be 'Unauthorized'

