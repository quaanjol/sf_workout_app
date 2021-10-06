public with sharing class CaresoftController {
    //public string thisAudioLink {get; set;}
    
    /*public CaresoftController() {
        string id = ApexPages.currentPage().getParameters().get('id');
        thisAudioLink = getCallAudio(id);
    }*/
    
	@AuraEnabled
    public static Caresoft_Call_Log__c saveCallLogCaresoft(string toNumber,
                                                           string fromNumber, 
                                                           Integer[] startTime, 
                                                           Double callDuration, 
                                                           string note, 
                                                           string status, 
                                                           string type, 
                                                           string ender,
                                                           string taskId) {
		system.debug('call duration from the beginning is ' + callDuration);
        DateTime stTime = DateTime.newInstance(startTime[0], startTime[1], startTime[2], startTime[3], startTime[4], startTime[5]);
        Caresoft_Call_Log__c cc = new Caresoft_Call_Log__c (To_Number__c = toNumber, 
                                                            From_Number__c = fromNumber,
                                                            Start_time__c = stTime, 
                                                            Call_Duration__c = callDuration,
                                                           	Call_note__c = note, 
                                                           	Status__c = status, 
                                                           	Type__c = type,
                                                           	Ender__c = ender,
                                                            Task_ID__c = taskId);
        try {
            insert cc;
            return cc;
        } catch (DmlException e) {
            system.debug('insert failed ' + e.getMessage());
            //system.debug('duration is ' + callDuration);
        }
        return null;
    }
    
    @AuraEnabled
    public static Task findMissedTask(string phoneNumber, string recordId) {
        string sub = 'Missed call from ' + phoneNumber;
        try {
            Task ta = [select Id, Subject, CallDisposition 
                   from Task 
                   where (Subject =: sub and CallDisposition = 'Missed') limit 1];
            return ta;
        } catch (Exception e) {
            Task newTask = new Task(Subject = 'Missed call from ' + phoneNumber,
								   Priority = 'High',
                                   CallDurationInSeconds = 0,
                                   Description = '',
                                   CallDisposition = 'Missed',
                                   CallType = 'Inbound',
                                   WhoId = recordId);
            insert newTask;
            return newTask;
        }
    }
    
    @AuraEnabled
    public static List<Caresoft_Call_Log__c> getCareSoftCallLogLinkTask (string taskId) {
		List<Caresoft_Call_Log__c> callLogs = [select Id, Name, Ender__c, From_Number__c, To_Number__c, Start_Time__c, Call_Duration__c, Status__c, Type__c 
                                				   from Caresoft_Call_Log__c 
                                				   where Task_ID__c =: taskId];
        return callLogs;
    }
    
    @RemoteAction
    @AuraEnabled
    public static string getCallAudio (string id) {
        List<Caresoft_Call_Log__c> callLogsById = [select Id, Name, Caresoft_Call_Id__c
                                				   from Caresoft_Call_Log__c 
                                				   where Id =: id];
        
        string callId = callLogsById[0].Caresoft_Call_Id__c;
        
        List<Caresoft_Call_Log__c> callLogs = [select Id, Name, Caresoft_Call_Id__c, Caresoft_Call_Audio__c
                                				   from Caresoft_Call_Log__c 
                                				   where Caresoft_Call_Id__c =: callId];
        
        Caresoft_Call_Log__c thisCallLog = callLogs[0];
        
        if(thisCallLog.Caresoft_Call_Id__c == null) {
            return 'This call log has no caresoft call id.';
        }
        
        if(thisCallLog.Caresoft_Call_Audio__c == null) {
            string userId = UserInfo.getUserId();
            User currentUser = [select Id, Caresoft_Team__c from User where Id =: userId];
            
            string csDomain = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Domain__c;
            string viceKey = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Vice_key__c;
            
            // get caresoft audio via API
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            
            req.setEndpoint('https://api.caresoft.vn/' + csDomain + '/api/v1/calls?call_id=' + callId);
            req.setMethod('GET');
            
            // authorization header
            string authorizationHeader = 'Bearer ' + viceKey;
            //string authorizationHeader = 'Bearer xJbZ2NnNg3Rd_T8';
            
            // content-type header
            string contentTypeHeader = 'application/json';
            
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', contentTypeHeader);
            
            try {
                res = http.send(req);
                //Map<String, Object> returnObject = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                //(Map<String, Object>) calls = ((Map<String, Object>)) returnObject.get('calls')[0];
                //string path = (string) calls.get('path');
                string responseValue = (string)res.getBody();
                string[] arr = responseValue.split('"');
                string audioLink = arr[19].replaceAll('\\\\', '');
                //string audioLink = (string)res.getBody();
                thisCallLog.Caresoft_Call_Audio__c = audioLink;
                try {
                    //update thisCallLog;
                } catch (DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
                
                //system.debug('Response is ' + res.getBody());
                return audioLink;
            } catch(System.CalloutException e) {
                System.debug('Callout error: ' + e);
                System.debug(res.toString());
                return 'Callout error: ' + res.toString();
            }
        } else {
            return thisCallLog.Caresoft_Call_Audio__c;
        }
    }
    
    @AuraEnabled
    public static List<CaresoftAgent> getAllAgents() {
        string userId = UserInfo.getUserId();
        User currentUser = [select Id, Caresoft_Team__c from User where Id =: userId];
            
        string csDomain = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Domain__c;
        string viceKey = Caresoft_Config_1__c.getvalues(currentUser.Caresoft_team__c).Vice_key__c;
        
        // get caresoft agents via API
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setEndpoint('https://api.caresoft.vn/' + csDomain + '/api/v1/agents');
        req.setMethod('GET');
        
        // authorization header
        string authorizationHeader = 'Bearer ' + viceKey;
        
        // content-type header
        string contentTypeHeader = 'application/json';
        
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', contentTypeHeader);
        
        try {
            res = http.send(req);
            CaresoftAgentReturn callRes = (CaresoftAgentReturn) System.JSON.deserialize(res.getBody(), CaresoftAgentReturn.class);
            system.debug(callRes.agents);
            return callres.agents;
            
        } catch(System.CalloutException e) {
            System.debug('Callout error: ' + e);
            System.debug('callout error response ' + res.toString());
            return null;
        }
    }
}