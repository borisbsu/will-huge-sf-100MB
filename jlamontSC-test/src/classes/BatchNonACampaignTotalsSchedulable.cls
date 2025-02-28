// **************************************************************************
// BatchNonACampaignTotalsSchedulable						(c) 2017 Sierra Club
//
//	Recalculates the Advocacy Action totals for marked Campaigns
//			When an Advocacy Action is inserted or updated, it is marked 
//		to e recalculated.  This class is called nightly to recalcuate 
//		the Advocacy_Action_Count__c value on the Campaign.
//
//	2017/03/22		VB		Original - Copied from batchCampaignAATotalsSchedulable
//
// **************************************************************************
global class BatchNonACampaignTotalsSchedulable implements Schedulable{
	
    global void execute(SchedulableContext sc){
    	
    	// This query attempts to Count the Advocacy Action totals for:
    	//		Campaigns that are Non-"Advocacy Form" Campaigns record types
    	Id AdvFormCampaignType = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Advocacy Form').getRecordTypeId();
		String query = 'SELECT id, kwac__Related_Action__c ' +
						'FROM kweos__EOCS_Data__c ' +
						'WHERE kwac__Related_Action__r.Advocacy_Action_Count_Dirty__c = true ' +
						'AND kwac__Related_Action__r.RecordTypeId != \'' + AdvFormCampaignType + '\' ' +
						'ORDER BY kwac__Related_Action__c';
        
        BatchNonACampaignTotals  countBatch = new BatchNonACampaignTotals(query);
        Id BatchProcessId = Database.ExecuteBatch(countBatch);
    }
}