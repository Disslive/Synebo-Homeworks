@isTest
public class CommentsCalloutMock implements HttpCalloutMock{

    private class CommentWrapper{
        String body;
        String email;
        Integer id; 
        String name; 
        Integer postId;
    }

    public HTTPResponse respond(HTTPRequest req){

        System.assertEquals('callout:JSONplaceholder/comments', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse(); 

        List<CommentWrapper> wrappers = new List<CommentWrapper>();
        CommentWrapper wrapper = new CommentWrapper();
        wrapper.body = '88585';
        wrapper.email ='test@mock.ua';
        wrapper.id = 101;
        wrapper.name ='name';
        wrapper.postId = 1;
        wrappers.add(wrapper);

        res.setHeader('Content-Type', 'application/json');
        res.setBody(JSON.serialize(wrappers));
        res.setStatusCode(200);

        return res;
    }
}
