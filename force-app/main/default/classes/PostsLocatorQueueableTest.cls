@isTest
public class PostsLocatorQueueableTest {
  
    @isTest
    private static void getAndPostPostsTest(){

        PostsCalloutsMock postsCalloutMock = new PostsCalloutsMock();
        Test.setMock(HttpCalloutMock.class, postsCalloutMock);
        Test.startTest();
            System.enqueueJob(new PostsLocatorQueueable());
        Test.stopTest();
        List<Post__c> postsToUpsertList = [SELECT Id
                                          	FROM Post__c];
        System.assertEquals(1, postsToUpsertList.size(), 'Records weren`t returned');

    }

}