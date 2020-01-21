@isTest
private class TestDevOrgLoginBatch {


	@testSetup
	static void setupDevOrgSettings(){
		List<Dev_Org_Setting__c> testDOSettings = 
			TestDevOrgLoginFactory.createDevOrgSettings(10, 4);
			
	}

	@isTest
	static void testBatchLogin(){

		MockDevOrgLoginResponseGen mockGen = new MockDevOrgLoginResponseGen(true);
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, mockGen);
		

		String devOrgQuery = 'SELECT Id, Active__c, cs__c, st__c, ck__c, pw__c, Username__c, Endpoint__c '
		                                   + ' FROM Dev_Org_Setting__c WHERE Active__c = TRUE';
		
		DevOrgLoginBatch dlb = new DevOrgLoginBatch(devOrgQuery, 'Username__c', 
		                'pw__c', 'st__c', 'Endpoint__c', 'ck__c', 'cs__c');                
		                
		Database.executeBatch(dlb);
		                                 


		Test.stopTest();

		List<Dev_Org_Login_Result__c> loginRes = [SELECT Id FROM Dev_Org_Login_Result__c WHERE Success__c = TRUE];

		System.assertEquals(10, loginRes.size(), 'Batch execution should have resulted in 10 Successful login results');


	}



}
