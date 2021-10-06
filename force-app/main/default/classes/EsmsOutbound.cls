@RestResource(urlMapping='/sms/v1/outbound')
global class EsmsOutbound {
	@HttpPOST
    global static String doPOST() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        SMS_Outbound_Log__c smsLogTest = new SMS_Outbound_Log__c();
        smsLogTest.Log__c = 'Not going to the if clause yet';
        smsLogTest.Notification_ID__c = 'Thus no noti ID';
        smsLogTest.Notification__c = 'EsmsOutbound class';
        insert smsLogTest;
        
        if(RestContext.request != null){
            // create new sms log
            SMS_Outbound_Log__c smsLog = new SMS_Outbound_Log__c();
            
            if (RestContext.request.requestBody.toString() != '') {
                try {
                    String xml = RestContext.request.requestBody.toString(); // XML 
					String jsonContent = XmlParser.xmlToJson(xml);
                    Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonContent);  
                    Map<String, Object> envelope = (Map<String, Object>) m.get('Envelope');
                    Map<String, Object> body = (Map<String, Object>) envelope.get('Body');
                    Map<String, Object> notifications = (Map<String, Object>) body.get('notifications');
                    Map<String, Object> notification = (Map<String, Object>) notifications.get('Notification');
                    Map<String, Object> thisObject = (Map<String, Object>) notification.get('sObject');
                    String notiId = (string) notification.get('Id');
                    
                    // save log
                    smsLog.Log__c = jsonContent;
                    //smsLog.Log__c = 'hello';
                    smsLog.Notification_ID__c = notiId;
                    smsLog.Notification__c = 'Not send sms yet';
                    insert smsLog;
                    return 'done';
                    
                } catch (Exception e) {
					system.debug(e.getMessage());
                    // save log
                    smsLog.Log__c = e.getMessage();
                    smsLog.Notification_ID__c = 'No notification ID returned';
                    smsLog.Notification__c = 'Failed';
                    insert smsLog;
                    return e.getMessage();
                }
                
            } else {
                // save log
                smsLog.Log__c = 'Loser!!!';
                smsLog.Notification_ID__c = 'No notification ID returned';
                smsLog.Notification__c = 'Body is empty.';
                insert smsLog;
            	system.debug('no response returned');
        	}
        }
        return 'test';
    }
    
    public static FPTSMSOAuthResponse getFPTToken(String phone) {
        string grantType = 'client_credentials';
        string clientId = '039911EAaF554c7C1fD562115f7764694d227045';
        string clientSecret = '34a0b2ca7e529db2106c8384926f055618daAba11e9e07d769d39b57086c4457eff26072';
        string scope = 'send_brandname_otp';
        string sessionId = 'abcde';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndpoint('http://app.sms.fpt.net/oauth2/token');
        request.setEndpoint('http://sandbox.sms.fpt.net/oauth2/token');
        request.setMethod('POST');
        string payload = 'client_id=' + clientId + '&client_secret=' + clientSecret + '&scope=' + scope + '&grant_type=' + grantType + '&session_id=' + sessionId;
		request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Content-Length', String.valueOf(payload.length()));
        request.setBody(payload);
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        
        // Parse the JSON response
        FPTSMSOAuthResponse result = (FPTSMSOAuthResponse) System.JSON.deserialize(response.getBody(), FPTSMSOAuthResponse.class);
        sendSMS(result, sessionId, phone);
        return result;
        //return request.getBody();
    }
    
    public static void sendSMS(FPTSMSOAuthResponse token, String sessionId, String phone) {
        String msg = 'Hello World';
        String message = EncodingUtil.base64Encode(Blob.valueof(msg));
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndpoint('http://app.sms.fpt.net/api/push-brandname-otp');
        request.setEndpoint('http://sandbox.sms.fpt.net/api/push-brandname-otp');
        request.setMethod('POST');
        string payload = 'access_token=' + token.access_token + '&session_id=' + sessionId + '&BrandName=FTI&Phone=' + phone + '&Message=' + message;
		request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Content-Length', String.valueOf(payload.length()));
        request.setBody(payload);
        HttpResponse response = http.send(request);
        System.debug('send message is ' + response.getBody());
    }
}