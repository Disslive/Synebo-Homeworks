trigger PostTrigger on Post__c (before delete) {

    if(Trigger.isBefore){
        if(Trigger.isDelete){
            System.enqueueJob(new PostsLocatorQueueable());
        }
    }

}