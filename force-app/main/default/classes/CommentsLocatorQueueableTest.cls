@isTest
public class CommentsLocatorQueueableTest {
    
    @TestSetup
    static void setup(){
        Post__c post = PostsTestDataFactory.getPost(1);
        insert post;
    }

    @isTest
    private static void getCommentsTest(){
        
        CommentsCalloutMock commentsCalloutMock = new CommentsCalloutMock();
        Test.setMock(HttpCalloutMock.class,commentsCalloutMock);

        Test.startTest();
            System.enqueueJob(new CommentsLocatorQueueable());
        Test.stopTest();

        List<Comment__c> comments = [SELECT Id
                                    FROM Comment__c];  

        System.assertEquals(1,comments.size(),'Comments weren`t returned');
    }
}
