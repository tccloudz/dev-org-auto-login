/**
 * @author Terence Chiu
 * @date 2020-01-15
 * @description Class handles logging into dev orgs
*/
public with sharing class DevOrgLoginService {

	public static Dev_Org_Login_Result__c login(String u, String p, String endP, String key, String cs){

		//LoginResult lr = new LoginResult();
		Dev_Org_Login_Result__c lr = new Dev_Org_Login_Result__c();
		Http h = new Http();
		HttpResponse resp;
		HttpRequest req = new HttpRequest();

		String reqBody = 'grant_type=password&client_id=' + key + '&client_secret=' + cs + '&username=' + u + '&password=' + p; 

		req.setEndpoint(endP);
		req.setBody(reqBody);
		req.setMethod('POST');

		try{
			resp = h.send(req);
			String respBody = resp.getBody();
			system.debug(respBody);
			lr.Success__c = parseLoginResult(respBody);
			lr.Error_Message__c = !lr.Success__c ? respBody : null; 
		}catch(Exception ex){
			String exMsg = 'Error during dev org login: ' + ex.getmessage();
			system.debug(LoggingLevel.ERROR, exMsg);
			lr.Success__c = false;
			lr.Error_Message__c = exMsg;
		}


		return lr;

	
	}

	private static Boolean parseLoginResult(String respBody){

		JSONParser parser = JSON.createParser(respBody);
		Boolean success = false;
		while(parser.nextToken() != null){
			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
				(parser.getText() == 'error')){

				success = false;
			}
			else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
				(parser.getText() == 'access_token')){

				success = true;
			}
			
		
		}

		return success;

	}

}
