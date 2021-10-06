@isTest
global class MockHttpResponseCaresoftControllerTest implements HttpCalloutMock  {
    // Implement this interface method
    global static HTTPResponse respond(HTTPRequest req) {
        string userId = UserInfo.getUserId();
        User currentUser = [select Id, Caresoft_domain__c, Caresoft_Key__c
                            from User where Id =: userId];
        
        string csDomain = currentUser.Caresoft_domain__c;
        string callId = '20210218105410-OUTULRVI-56513';
        
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://api.caresoft.vn/' + csDomain + '/api/v1/calls?call_id=' + callId, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"code":"OK","numFound":1,"calls":[{"id":175266831,"customer_id":109031669,"call_id":"20210218105410-OUTULRVI-56513","path":"https://f5.caresoft.vn:29993/f/b6a0d15a9cf87c6cef402e5131f24f6b//602de52f883ec450174db468/6b0e12c9b3304d8e7878e9f4e1745194/e820e1bf43f07087fe0ea61dcb6c80dd.mp3","path_download":"https://f5.caresoft.vn:29993/f/b6a0d15a9cf87c6cef402e5131f24f6b//602de52f883ec450174db468/cd0490cefca753018d9f55bf9fff4739/e820e1bf43f07087fe0ea61dcb6c80dd.mp3","caller":"0338566226","called":"0865861766","user_id":"35993084","agent_id":"16500","group_id":8564,"call_type":1,"start_time":"2021-02-18 10:54:10","call_status":"meetAgent","end_time":"2021-02-18 10:54:27","wait_time":"00:00:08","hold_time":"00:00:00","talk_time":"00:00:09","end_status":"system","ticket_id":219587508,"last_agent_id":"16500","last_user_id":35993084,"call_survey":"NO","call_survey_result":null}]}');
        res.setStatusCode(200);
        return res;
    }
}