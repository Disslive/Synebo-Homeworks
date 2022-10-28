public with sharing class PostTriggerHandler {
    

    public static void updatePosts(List<Post__c> newPostsList, Map<Id, Post__c> oldPostsMap){
        List<Post__c> updatedPosts = new List<Post__c>();
        for(Post__c post_i : newPostsList){
            if(post_i.Title__c != oldPostsMap.get(post_i.Id).Title__c ||
            post_i.Body__c != oldPostsMap.get(post_i.Id).Body__c){
                updatedPosts.add(post_i);
            }
        }

        if(!updatedPosts.isEmpty()){
            System.enqueueJob(new PostsLocatorQueueable());
        }

    }

}
