@isTest
public with sharing class MockDevOrgLoginResponseGen implements HttpCalloutMock{

	private Boolean isSuccess;

	
	public MockDevOrgLoginResponseGen(Boolean s){

		isSuccess = s;
	}


	public HttpResponse respond(HttpRequest req){

		HttpResponse resp = new HttpResponse();

		System.assertEquals('POST', req.getMethod(), 'Callout method should be POST');
		
		resp.setBody(generateResp(isSuccess));
		resp.setStatusCode(200);	


		return resp;

	}

	private String generateResp(Boolean success){
		String resp = '';

		JSONGenerator gen = JSON.createGenerator(true);

		gen.writeStartObject();


		if(success){

			gen.writeStringField('access_token', 'SESSIONID12345');
			gen.writeStringField('instance_url', 'https://test.salesforce.com');
			gen.writeStringField('access_token', 'SESSIONID12345');
			
		}
		else{
			gen.writeStringField('error', 'invalid_grent');
			gen.writeStringField('error_description', 'authentication failure');
			
		}

		gen.writeEndObject();


		

		return gen.getAsString();
	}


}
