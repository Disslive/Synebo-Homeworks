trigger CourseTrigger on Course__c (before insert) {

    CourseTriggerHandler triggerHandler = new CourseTriggerHandler();
    if(Trigger.isBefore){

        if(Trigger.isInsert){
            triggerHandler.changeInvalidNumber(Trigger.New);
        }
    } 

}