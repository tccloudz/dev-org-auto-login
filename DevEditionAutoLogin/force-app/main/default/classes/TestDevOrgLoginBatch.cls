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

	@isTest
	static void testScheduleBatchLogin(){


		String CRON_EXP = '0 0 0 3 9 ? 2050';


		MockDevOrgLoginResponseGen mockGen = new MockDevOrgLoginResponseGen(true);
		
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, mockGen);

		ScheduleDevOrgLogin schedLogin = new ScheduleDevOrgLogin();

		String jobId = System.schedule(
			'testDevOrgBatchLogin',
			CRON_EXP,
			new ScheduleDevOrgLogin()
					
		);

		List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered,
			NextFireTime FROM CronTrigger WHERE Id =: jobId LIMIT 1];


		System.assertEquals(CRON_EXP, ct[0].CronExpression);

		schedLogin.execute(null);
		Test.stopTest();

		List<Dev_Org_Login_Result__c> loginRes = [SELECT Id FROM Dev_Org_Login_Result__c WHERE Success__c = TRUE];

		System.assertEquals(10, loginRes.size(), 'Batch execution should have resulted in 10 Successful login results');
	}



}
