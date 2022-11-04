public with sharing class PostTriggerHandler {
    
    public static void updatePostsInformation(){
        System.enqueueJob(new PostsLocatorQueueable());
    }
}
