trigger PostTrigger on Post__c (before update) {

    if(Trigger.isBefore){
        if(Trigger.isUpdate){
            PostTriggerHandler.updatePosts(Trigger.New, Trigger.oldMap);
        }
    }

}