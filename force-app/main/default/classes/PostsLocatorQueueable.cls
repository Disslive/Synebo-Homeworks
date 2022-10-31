public with sharing class PostsLocatorQueueable implements Queueable, Database.AllowsCallouts{
   
    private static String ENDPOINT_BASE = 'callout:JSONplaceholder';

    private class Post {
        public Integer userId;
        public Integer id;
        public String title;
        public String body;
    }

    public void execute(QueueableContext context){
        List<Post> returnedPostsList = getAllPostsCallout();
        createPostCallout();
        List<Post__c> postsToUpsertList = new List<Post__c>();
        if(returnedPostsList !=null){

            for(Post post_i : returnedPostsList){
                postsToUpsertList.add(new Post__c(Post_Id__c = post_i.id, 
                                                    User_Id__c = post_i.userId, 
                                                    Title__c = post_i.title, 
                                                    Body__c = post_i.body));
            }
            
            upsert postsToUpsertList Post_Id__c;
        }
        System.enqueueJob(new CommentsLocatorQueueable());
    }

    private static List<Post> getAllPostsCallout(){
        
        String endpoint = ENDPOINT_BASE + '/posts';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){

            List<Post> postsList = (List<Post>) JSON.deserialize(response.getBody(), List<Post>.class);
            return postsList;
        }
        return null;

    }

    private static void createPostCallout(){

        String endpoint = ENDPOINT_BASE + '/posts';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        Post newPost = new Post();
        newPost.userId = 1;
        newPost.title = 'Some title';
        newPost.body = 'Some body';
        String requestBody = JSON.serialize(newPost);
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(requestBody);
        HttpResponse response = http.send(request);
        if(response.getStatusCode() != 201) {
    		System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
		} else {
    		System.debug(response.getBody());
		}
    }

}