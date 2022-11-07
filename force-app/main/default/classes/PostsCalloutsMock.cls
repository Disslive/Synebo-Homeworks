@isTest
public class PostsCalloutsMock implements HttpCalloutMock {
    
    private class PostWrapper {
        public Integer userId;
        public Integer id;
        public String title;
        public String body;
    }

    public HTTPResponse respond(HTTPRequest req){
		
        System.assertEquals('callout:JSONplaceholder/posts', req.getEndpoint());
		HttpResponse res = new HttpResponse();        
        if(req.getMethod() == 'GET'){
        	List<PostWrapper> wrappers = new List<PostWrapper>();
        	PostWrapper wrapper = new PostWrapper();
        	wrapper.userId = 1000;
        	wrapper.id = 1001;
        	wrapper.title = '343';
        	wrapper.body ='123';
        	wrappers.add(wrapper);
        	res.setHeader('Content-Type', 'application/json');
        	res.setBody(JSON.serialize(wrappers));
            res.setStatusCode(200);
        } else if(req.getMethod() == 'POST'){
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(201);
        }
        
        return res;
    }

}