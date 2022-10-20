trigger StudentTrigger on Student__c (after insert, after delete) {

    StudentTriggerHandler triggerHandler = new StudentTriggerHandler();
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            triggerHandler.calculateStudentsCount(Trigger.New, Trigger.operationType.name());
        } else if(Trigger.isDelete){
            triggerHandler.calculateStudentsCount(Trigger.Old, Trigger.operationType.name());
        }
    }

}