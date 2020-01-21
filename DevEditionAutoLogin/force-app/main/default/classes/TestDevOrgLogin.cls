/**
 * @author Terence Chiu
 * @date 2020-01-17
 * @description Test class to test DevOrgLoginService methods
 *
 */
@isTest
private class TestDevOrgLogin {

    @testSetup
    static void setupDevOrgSettings(){

	List<Dev_Org_Setting__c> testDOSettings = TestDevOrgLoginFactory.createDevOrgSettings(4, 1);
	Integer numOfActive = 0;
	Integer numOfInactive = 0;
	Integer numOfCreated = 0;
	for(Dev_Org_Setting__c testDOS : testDOSettings){
		Boolean act = testDOS.Active__c;
		numOfActive = act ? numOfActive + 1 : numOfActive;
		numOfInactive = !act ? numOfInactive + 1 : numOfInActive;
		numOfCreated = testDOS.Id != null ? numOfCreated + 1 : numOfCreated;
	}

	System.assertEquals(4, numOfActive, 'Four setting records should be active');
	System.assertEquals(1, numOfInactive, 'one setting record should be inactive');
	System.assertEquals(5, numOfCreated, 'Five setting records should be inserted successfully');


	/*for(Integer i = 0; i < 5; i++){

		Boolean active = i == 4 ? false : true;
		testDOSettings.add(

			new Dev_Org_Setting__c(

				Name = 'DevOrgTest' + i,
				Active__c = active,
				cs__c = 'CSKEY' + i,
				pw__c = 'pw' + i,
				Username__c = 'testdev' + i + '@testdev.test',
				ck__c = 'ck' + i,
				Endpoint__c = 'https://test.salesforce.com',
				st__c = 'st' + i
				
			)
		);


	}*/

	/*try{
		insert testDOSettings;
	}catch(Exception ex){
		System.debug(LoggingLevel.ERROR, 'Error during test dev org setting setup: ' + ex.getMessage());
	}*/
	



    }


    @isTest
    static void testLoginSuccess() {

	MockDevOrgLoginResponseGen mockGen = new MockDevOrgLoginResponseGen(true);
//	List<Dev_Org_Login_Result__c> loginRes = new List<Dev_Org_Login_Result__c>();
	Integer successCnt = 0;
	List<Dev_Org_Setting__c> devOrgSetting = [SELECT Id, Username__c, cs__c, pw__c, ck__c, Endpoint__c, st__c ,Active__c FROM Dev_Org_Setting__c WHERE Active__c = TRUE];



	Test.startTest();

	Test.setMock(HttpCalloutMock.class, mockGen);
	
	for(Dev_Org_Setting__c dos : devOrgSetting){
		Dev_Org_Login_Result__c loginRes = DevOrgLoginService.login(dos.Username__c, dos.pw__c + dos.st__c, dos.Endpoint__c, dos.ck__c, dos.cs__c);
		successCnt = loginRes.Success__c ? successCnt + 1 : successCnt;
	}

	Test.stopTest();

	system.assertEquals(devOrgSetting.size(), successCnt, 'All four active dev org settings should result in a successful login attempt');

    
    }

    @isTest
    static void testLoginFailure() {

	MockDevOrgLoginResponseGen mockGen = new MockDevOrgLoginResponseGen(false);
//	List<Dev_Org_Login_Result__c> loginRes = new List<Dev_Org_Login_Result__c>();
	Integer errCnt = 0;
	List<Dev_Org_Setting__c> devOrgSetting = [SELECT Id, Username__c, cs__c, pw__c, ck__c, Endpoint__c, st__c ,Active__c FROM Dev_Org_Setting__c WHERE Active__c = TRUE];



	Test.startTest();

	Test.setMock(HttpCalloutMock.class, mockGen);
	
	for(Dev_Org_Setting__c dos : devOrgSetting){
		Dev_Org_Login_Result__c loginRes = DevOrgLoginService.login(dos.Username__c, dos.pw__c + dos.st__c, dos.Endpoint__c, dos.ck__c, dos.cs__c);
		errCnt = !loginRes.Success__c ? errCnt + 1 : errCnt;
	}

	Test.stopTest();

	system.assertEquals(devOrgSetting.size(), errCnt, 'All four active dev org settings should result in a failed login attempt');

      

    }


    @isTest
    static void testLoginCalloutEx() {

	MockDevOrgLoginResponseGen mockGen = new MockDevOrgLoginResponseGen(true);
//	List<Dev_Org_Login_Result__c> loginRes = new List<Dev_Org_Login_Result__c>();
	Integer errCnt = 0;
	List<Dev_Org_Setting__c> devOrgSetting = [SELECT Id, Username__c, cs__c, pw__c, ck__c, Endpoint__c, st__c ,Active__c FROM Dev_Org_Setting__c WHERE Active__c = TRUE];

	//Test.startTest();

	Test.setMock(HttpCalloutMock.class, mockGen);
	
	for(Dev_Org_Setting__c dos : devOrgSetting){
		Dev_Org_Login_Result__c loginRes = DevOrgLoginService.login(dos.Username__c, dos.pw__c + dos.st__c, dos.Endpoint__c, dos.ck__c, dos.cs__c);
		String exMsg = loginRes.Error_Message__c != null ? loginRes.Error_Message__c : '';
		errCnt = !loginRes.Success__c && exMsg.contains('Error during dev org login:') ? errCnt + 1 : errCnt;
	}

	//Test.stopTest();

	system.assertEquals(devOrgSetting.size(), errCnt, 'All four active dev org settings should result in a callout exception');

      
    }
    
    
}
