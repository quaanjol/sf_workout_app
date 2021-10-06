@isTest
global class MockAgentsResponseCaresoftControllerTest implements HttpCalloutMock {
	// Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        string userId = UserInfo.getUserId();
        User currentUser = [select Id, Caresoft_domain__c, Caresoft_Key__c
                            from User where Id =: userId];
        
        string csDomain = currentUser.Caresoft_domain__c;
        string authorizationHeader = 'Bearer ' + currentUser.Caresoft_Key__c;
        
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://api.caresoft.vn/' + csDomain + '/api/v1/agents', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', authorizationHeader);
        res.setBody('{"code":"ok","agents":[{"id":35993084,"username":"Sale online 1","email":"vantaicaresoft@gmail.com","phone_no":"0973409673","agent_id":"16500","created_at":"2018-08-27 09:00:55","updated_at":"2021-02-23 10:35:15","group_id":8564,"group_name":"Sale online","role_id":1,"login_status":"NOT AVAILABLE","call_status":"AVAILABLE"},{"id":90388295,"username":"H\u00f9ng -T\u0110V","email":"vantaitest@gmail.com","phone_no":"0987654345","agent_id":"16503","created_at":"2020-05-12 17:41:15","updated_at":"2021-02-18 22:26:23","group_id":8564,"group_name":"Sale online","role_id":1,"login_status":"LOGOUT","call_status":"AVAILABLE"},{"id":87125730,"username":"H\u00e0ng B\u00e0i","email":"QALead@gmail.com","phone_no":"0886868686","agent_id":"16502","created_at":"2020-02-12 10:34:09","updated_at":"2021-02-18 22:34:40","group_id":9401,"group_name":"C\u1eeda h\u00e0ng","role_id":2,"login_status":"LOGOUT","call_status":"AVAILABLE"},{"id":89031351,"username":"L\u00e1ng H\u1ea1","email":"Test@gmail.com","phone_no":"0937373737","agent_id":"16505","created_at":"2020-03-30 09:27:53","updated_at":"2021-02-18 22:34:12","group_id":9401,"group_name":"C\u1eeda h\u00e0ng","role_id":2,"login_status":"LOGOUT","call_status":"AVAILABLE"},{"id":94068159,"username":"\u0110oan Trang","email":"trang.trandoan@tiki.vn","phone_no":"0981677466","agent_id":"16518","created_at":"2020-07-23 15:12:03","updated_at":"2021-02-18 22:26:15","group_id":8564,"group_name":"Sale online","role_id":2,"login_status":"LOGOUT","call_status":"AVAILABLE"},{"id":99091781,"username":"Quang Anh","email":"qanhmatngua@gmail.com","phone_no":"0358946677","agent_id":"16506","created_at":"2020-10-14 14:53:14","updated_at":"2021-02-24 17:23:44","group_id":10269,"group_name":"G\u1ecdi ch\u1ed1t","role_id":2,"login_status":"LOGOUT","call_status":"AVAILABLE"},{"id":91122725,"username":"Th\u00e1i H\u00e0","email":"QA@gmail.com","phone_no":"0986666888","agent_id":"16504","created_at":"2020-06-01 09:58:30","updated_at":"2021-02-18 22:33:57","group_id":9401,"group_name":"C\u1eeda h\u00e0ng","role_id":8,"login_status":"LOGOUT","call_status":"AVAILABLE"}]}');
        res.setStatusCode(200);
        return res;
    }
}