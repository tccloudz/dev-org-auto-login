@isTest
public class TestDevOrgLoginFactory {


	public static List<Dev_Org_Setting__c> createDevOrgSettings(Integer numActive, Integer numInactive ){

		List<Dev_Org_Setting__c> devOrgSettings = new List<Dev_Org_Setting__c>();

		

		for(Integer i = 0; i < numActive; i++){
		
			devOrgSettings.add(
				new Dev_Org_Setting__c(
					Name = 'DevOrgTest' + i,
					Active__c = true,
					cs__c = 'CSKEY' + i,
					pw__c = 'pw' + i,
					Username__c = 'testdev' + i + '@testdev.test',
					ck__c = 'ck' + i,
 					Endpoint__c = 'https://test.salesforce.com',
 				        st__c = 'st' + i
				)
			);
		}

		for(Integer j = 0; j < numInactive; j++){
		
			devOrgSettings.add(
				new Dev_Org_Setting__c(
					Name = 'DevOrgTestInActive' + j,
					Active__c = false,
					cs__c = 'CSKEY' + j,
					pw__c = 'pw' + j,
					Username__c = 'testdev' + j + '@testdev.test',
					ck__c = 'ck' + j,
 					Endpoint__c = 'https://test.salesforce.com',
 				        st__c = 'st' + j
				)
			);

		}	
		


		try{
			insert devOrgSettings;
		}catch(Exception ex){
			System.debug(LoggingLevel.ERROR, 'Error during test dev org setting creation: ' + ex.getMessage());
		}


		return devOrgSettings;

	}


}
