public with sharing class CommentsLocatorQueueable implements Queueable, Database.AllowsCallouts{
 
    private static String ENDPOINT_BASE = 'callout:JSONplaceholder';

    private class Comment{
        String body;
        String email;
        Integer id; 
        String name; 
        Integer postId;
    }

    public void execute(QueueableContext context){

        List<Comment__c> commentsToUpsert = new List<Comment__c>();
        List<Comment> returnedCommentsList = getAllCommentsCallout();
        if(returnedCommentsList!=null){

            for(Comment comment_i : returnedCommentsList){
               commentsToUpsert.add(new Comment__c(Body__c = comment_i.body,
                                                    Email__c = comment_i.email,
                                                    CommentId__c = comment_i.id,
                                                    Authors_name__c = comment_i.name,
                                                    Post_Id__c = comment_i.postId));
            }

            upsert commentsToUpsert CommentId__c;
        }

    }

    private static List<Comment> getAllCommentsCallout(){

        String endpoint = ENDPOINT_BASE + '/comments';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){

            List<Comment> postsList = (List<Comment>) JSON.deserialize(response.getBody(), List<Comment>.class);
            return postsList;
        }
        return null;
    }

}
