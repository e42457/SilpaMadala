Feature: PBI55037 Orchestration 
	
@200-Status-OK
Scenario:Status OK
	Given User has Request File'RequestFiles\Ernst55037FeeReq.xml'
	And User has Endpoint '/quote/feeservicequote '
	When User Posted the file with contentType as 'text/xml'
	Then Status code should be 'OK'

@404-Notfound
Scenario:Invalid Endpoint
	Given User has Request File'RequestFiles\Ernst55037FeeReq.xml'
	And User has Endpoint '/feeservicequote'
	When User Posted the file with contentType as 'text/xml'
	Then Status code should be 'NotFound'

@401-NotAuthorized
Scenario:Invalid Bearer Toekn
	Given User has Request File'RequestFiles\Ernst55037FeeReq.xml'
	And User has Endpoint '/quote/feeservicequote'
	When User Posted the file without authorization and contentType as 'text/xml'
	Then Status code should be 'Unauthorized'

@400-BadRequest
Scenario:Invalid Content
	Given User has Request File'RequestFiles\Ernst55037FeeReq.xml'
	And User has Endpoint '/quote/feeservicequote '
	When User Posted the file with contentType as 'application/json'
	Then Status code should be 'BadRequest'