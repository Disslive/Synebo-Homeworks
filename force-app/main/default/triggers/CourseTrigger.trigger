trigger CourseTrigger on Course__c (before insert, after insert) {

    CourseTriggerHandler triggerHandler = new CourseTriggerHandler();
    if(Trigger.isBefore){

        if(Trigger.isInsert){
            triggerHandler.changeNegativeNumber(Trigger.new);
        }
    } else if(Trigger.isAfter){
        if(Trigger.isInsert){
            
        }
    }

}