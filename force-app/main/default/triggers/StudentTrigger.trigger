trigger StudentTrigger on Student__c (after insert, after delete, after update) {

    StudentTriggerHandler triggerHandler = new StudentTriggerHandler();
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            triggerHandler.calculateStudentsCount(Trigger.New, null);
        } else if(Trigger.isDelete){
            triggerHandler.calculateStudentsCount(null, Trigger.oldMap);
        } else if(Trigger.isUpdate){
            triggerHandler.calculateStudentsCount(Trigger.New, Trigger.oldMap);
        }
    }

}