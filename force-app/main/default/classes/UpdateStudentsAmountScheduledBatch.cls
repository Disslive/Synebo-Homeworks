public with sharing class UpdateStudentsAmountScheduledBatch implements Database.Batchable<sObject>, Schedulable {
    
    public Database.QueryLocator start(Database.BatchableContext dbc){
        return Database.getQueryLocator([SELECT Id, Total_Students__c FROM Department__c]);
    }

    public void execute(Database.BatchableContext dbc, List<Department__c> scope){
        List<Department__c> departmentsToUpdateList = new List<Department__c>();

        Map<Id, AggregateResult> studentsCountMap =  new Map<id,AggregateResult>([SELECT Group__r.Department__c Id, Count(Id) totalStudents
                                                                                FROM Student__c 
                                                                                WHERE Active__c = true AND Group__r.Department__c IN :scope
                                                                                GROUP BY Group__r.Department__c]);

        for(Department__c dep : scope){

            AggregateResult aggrResult = studentsCountMap.get(dep.Id);
            Integer count = (Integer)aggrResult.get('totalStudents');
            if(dep.Total_Students__c != count){
                dep.Total_Students__c = count;
                departmentsToUpdateList.add(dep);
            }
        }

        if(!departmentsToUpdateList.isEmpty()){
            update departmentsToUpdateList;
        }

    }

    public void finish(Database.BatchableContext dbc) {
        System.debug('Students count was recalculated');
    }
    public void execute(SchedulableContext SC){
        Database.executeBatch(new UpdateStudentsAmountScheduledBatch());
    }
}
