@isTest
private class CaresoftControllerTest {
    @isTest static void saveCallLogCaresoftTest1() {
        // save new task
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk;
        
        string toNumber = '0338566226';
        string fromNumber = '';
        Integer[] startTime = new Integer[]{2020, 11, 22, 18, 30, 0};
		Double duration = 22.9;
        string note = 'this is call note created from test class';
        string status = 'Successful';
        string type = 'Outbound';
        string ender = 'Agent';
        Caresoft_Call_Log__c clc = new Caresoft_Call_Log__c();
		clc = CaresoftController.saveCallLogCaresoft(toNumber, fromNumber, startTime, duration, note, status, type, ender, tsk.Id);
        System.assertEquals('this is call note created from test class', clc.Call_note__c);
    }
    
    @isTest static void saveCallLogCaresoftTest2() {
        // save new task
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk;
        
        string toNumber = '0338566226';
        string fromNumber = '';
        Integer[] startTime = new Integer[]{2020, 11, 22, 18, 30, 0};
		Double duration = 22.9;
        string note = 'this is call note created from test class';
        string status = 'Succesful';
        string type = 'Outbound';
        string ender = 'Agent';
        Caresoft_Call_Log__c clc = new Caresoft_Call_Log__c();
		clc = CaresoftController.saveCallLogCaresoft(toNumber, fromNumber, startTime, duration, note, status, type, ender, tsk.Id);
        System.assertEquals(null, clc);
    }
    
    @isTest static void findMissedTask() {
        // save new account
        Contact a = new Contact(LastName = 'Test Account');
        insert a;
        
        // save new task
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'New';
        tsk.Type = 'Call';
        tsk.CallDisposition = 'Missed';
        tsk.Subject = 'Missed call from 0338566226';
        tsk.WhoId = a.Id;
        insert tsk;
        
        Task tt = CaresoftController.findMissedTask('0338566226', a.Id);
        System.assertEquals(tt.Subject, 'Missed call from 0338566226');
    }
    
    @isTest static void findMissedTask2() {
        // save new account
        Contact a = new Contact(LastName = 'Test Account');
        insert a;
        
        Task tt = CaresoftController.findMissedTask('0338566226', a.Id);
        System.assertEquals(tt.WhoId, a.Id);
    }
    
    @isTest static void getCareSoftCallLogLinkTask() {
        // save new task
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'New';
        tsk.Type = 'Call';
        tsk.CallDisposition = 'Missed';
        tsk.Subject = 'Missed call from 0338566226';
        insert tsk;
        
        List<Caresoft_Call_Log__c> callLogs = CaresoftController.getCareSoftCallLogLinkTask(tsk.Id);
        System.assertEquals(callLogs.size(), 0);
    }
    
    @isTest static void getCallAudio1() {
        // save new task
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk;
        
        string toNumber = '0338566226';
        string fromNumber = '';
        Integer[] startTime = new Integer[]{2020, 11, 22, 18, 30, 0};
		Double duration = 22.9;
        string note = 'this is call note created from test class';
        string status = 'Successful';
        string type = 'Outbound';
        string ender = 'Agent';
        Caresoft_Call_Log__c clc = new Caresoft_Call_Log__c();
		clc = CaresoftController.saveCallLogCaresoft(toNumber, fromNumber, startTime, duration, note, status, type, ender, tsk.Id);
        clc.Caresoft_Call_Id__c = '20210218105410-OUTULRVI-56513';
        
        // insert audio link
        string expectedLink = 'https://f5.caresoft.vn:29993/f/b6a0d15a9cf87c6cef402e5131f24f6b//602de52f883ec450174db468/6b0e12c9b3304d8e7878e9f4e1745194/e820e1bf43f07087fe0ea61dcb6c80dd.mp3';
        clc.Caresoft_Call_Audio__c = expectedLink;
        update clc;
        System.assertEquals(expectedLink, CaresoftController.getCallAudio(clc.id));
    }
    
    @isTest static void getCallAudio2() {
        // save new task
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk;
        
        string toNumber = '0338566226';
        string fromNumber = '';
        Integer[] startTime = new Integer[]{2020, 11, 22, 18, 30, 0};
		Double duration = 22.9;
        string note = 'this is call note created from test class';
        string status = 'Successful';
        string type = 'Outbound';
        string ender = 'Agent';
        Caresoft_Call_Log__c clc = new Caresoft_Call_Log__c();
		clc = CaresoftController.saveCallLogCaresoft(toNumber, fromNumber, startTime, duration, note, status, type, ender, tsk.Id);
        
        System.assertEquals('This call log has no caresoft call id.', CaresoftController.getCallAudio(clc.id));
    }
    
    @isTest static void getCallAudio3() {
        // save new task
        Task tsk = new Task();
        tsk.Subject = 'Follow up with Lead';
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'New';
        tsk.Type = 'Call';
        insert tsk;
        
        string toNumber = '0338566226';
        string fromNumber = '';
        Integer[] startTime = new Integer[]{2020, 11, 22, 18, 30, 0};
		Double duration = 22.9;
        string note = 'this is call note created from test class';
        string status = 'Successful';
        string type = 'Outbound';
        string ender = 'Agent';
        Caresoft_Call_Log__c clc = new Caresoft_Call_Log__c();
		clc = CaresoftController.saveCallLogCaresoft(toNumber, fromNumber, startTime, duration, note, status, type, ender, tsk.Id);
        clc.Caresoft_Call_Id__c = '20210218105410-OUTULRVI-56513';
        
        update clc;
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseCaresoftControllerTest());
        // get caresoft audio via API
        string userId = UserInfo.getUserId();
        User currentUser = [select Id, Caresoft_Team__c from User where Id =: userId];
            
        Caresoft_Config_1__c setting = new Caresoft_Config_1__c();
        setting.Name = 'Demo';
        setting.Domain__c = 'vantai';
        setting.Main_key__c = 'xJbZ2NnNg3Rd_T8';
        setting.Vice_key__c = 'Yl6jKiclHtTSMq0 ';
        insert setting;
        
        string csDomain = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Domain__c;
        string mainKey = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Main_key__c;
        string viceKey = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Vice_key__c;
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://api.caresoft.vn/' + csDomain + '/api/v1/calls?call_id=' + clc.Caresoft_Call_Id__c);
        req.setMethod('GET');
        
        // authorization header
        string authorizationHeader = 'Bearer ' + mainKey;
        
        // content-type header
        string contentTypeHeader = 'application/json';
        
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', contentTypeHeader);
        
        string audioLink = CaresoftController.getCallAudio(clc.id);
        HTTPResponse res = MockHttpResponseCaresoftControllerTest.respond(req);
        string mockLink = ((string)res.getBody()).split('"')[19];
        System.assertEquals(audioLink, 'Callout error: System.HttpResponse[Status=null, StatusCode=0]');
    }
    
    @isTest static void getAllAgents1() {
        string userId = UserInfo.getUserId();
        User currentUser = [select Id, Caresoft_Team__c from User where Id =: userId];
        
        Caresoft_Config_1__c setting = new Caresoft_Config_1__c();
        setting.Name = 'Demo';
        setting.Domain__c = 'vantai';
        setting.Main_key__c = 'xJbZ2NnNg3Rd_T8';
        setting.Vice_key__c = 'Yl6jKiclHtTSMq0 ';
        insert setting;
            
        string csDomain = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Domain__c;
        string mainKey = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Main_key__c;
        string viceKey = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Vice_key__c;
        
        // mock http test starts
        Test.setMock(HttpCalloutMock.class, new MockAgentsResponseCaresoftControllerTest());
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://api.caresoft.vn/' + csDomain + '/api/v1/agents');
        req.setMethod('GET');
        
        // authorization header
        string authorizationHeader = 'Bearer ' + mainKey;
        
        // content-type header
        string contentTypeHeader = 'application/json';
        
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', contentTypeHeader);
        HTTPResponse res = MockAgentsResponseCaresoftControllerTest.respond(req);
        CaresoftAgentReturn callRes = (CaresoftAgentReturn) System.JSON.deserialize(res.getBody(), CaresoftAgentReturn.class);
        
        List<CaresoftAgent> lca = CaresoftController.getAllAgents();
        
        System.assertNotEquals(lca, callRes.agents);
    }
}