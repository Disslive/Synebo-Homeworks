public  class PostsTestDataFactory {
    public static Post__c getPost(Integer postId){
        return new Post__c(Post_Id__c = postId);
    }
}
