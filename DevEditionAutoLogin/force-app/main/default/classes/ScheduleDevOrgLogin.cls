global  with sharing class ScheduleDevOrgLogin implements Schedulable{

	global void execute(SchedulableContext SC){

		String devOrgQuery = 'SELECT Id, Active__c, cs__c, st__c, ck__c, pw__c, Username__c, Endpoint__c '
		 		   + ' FROM Dev_Org_Setting__c WHERE Active__c = TRUE';
		
		DevOrgLoginBatch dlb = new DevOrgLoginBatch(devOrgQuery, 'Username__c', 
		'pw__c', 'st__c', 'Endpoint__c', 'ck__c', 'cs__c'); 		   

		Database.executeBatch(dlb, 1);

	
	}

}
