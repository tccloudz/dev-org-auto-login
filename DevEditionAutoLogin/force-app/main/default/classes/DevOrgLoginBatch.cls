global with sharing class DevOrgLoginBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{

	global final String query;
	global final String pwField;
	global final String uField;
	global final String stField;
	global final String keyField;
	global final String csField;
	global final String endPtField;


	global DevOrgLoginBatch(String q, String u, String p, String st, String e, String k, String cs){
		query = q;
		pwField = p;
		uField = u;
		stField = st;
		keyField = k;
		csField = cs;
		endPtField = e;
	}

	global Database.QueryLocator start(Database.BatchableContext BC){
		System.debug('query: ' + query);
		return Database.getQueryLocator(query); 
	} 

	global void execute(Database.BatchableContext BC, List<sObject> scope){
	

		List<Dev_Org_Login_Result__c> loginResLst = new List<Dev_Org_Login_Result__c>();

		for(sObject sObj : scope){
			String u = (String)sObj.get(uField);
			String p = (String)sObj.get(pwField);
			String st = (String)sObj.get(stField);
			String ep = (String)sObj.get(endPtField);
			String ck = (String)sObj.get(keyField);
			String cs = (String)sObj.get(csField);


			Dev_Org_Login_Result__c lr =  DevOrgLoginService.login(u, p+st, ep, ck, cs);
			lr.Dev_Org_Setting__c = (String) sObj.get('Id');
			loginResLst.add(lr);
		}


		try{
			insert loginResLst;
		}catch(DMLException ex){
			System.debug(LoggingLevel.ERROR, 'Error during dev org login result insertion: ' + ex.getMessage());
		}
		
	}

	global void finish(Database.BatchableContext BC){
	}

}
