@RestResource(urlMapping='/zalo/v2/outbound')
global class ZaloWebhook {
	@HttpPOST
    global static String doPOST() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        SMS_Outbound_Log__c smsLogTest = new SMS_Outbound_Log__c();
        smsLogTest.Log__c = 'Not going to the if clause yet';
        smsLogTest.Notification_ID__c = 'Thus no noti ID';
        smsLogTest.Notification__c = 'zalowebhook class';
        //insert smsLogTest;
        
        if(RestContext.request != null){
            if (RestContext.request.requestBody.toString() != '') {
                try {
                    Zalo_Outbound_Log_Test__c zc = new Zalo_Outbound_Log_Test__c();
                    String xml = RestContext.request.requestBody.toString(); // XML 
					String jsonContent = XmlParser.xmlToJson(xml);
                    Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(jsonContent);  
                    Map<String, Object> envelope = (Map<String, Object>) m.get('Envelope');
                    Map<String, Object> body = (Map<String, Object>) envelope.get('Body');
                    Map<String, Object> notifications = (Map<String, Object>) body.get('notifications');
                    Map<String, Object> notification = (Map<String, Object>) notifications.get('Notification');
                    Map<String, Object> thisObject = (Map<String, Object>) notification.get('sObject');
                    
                    string accId = (string) thisObject.get('Id');
                    Account aa = [select Id, Name, LastModifiedDate, Phone from Account Where Id =: accId limit 1]; 
                    
                    
                    system.debug(notification);
                    string notiiii = (string) notification.get('Id');
                    
                    // sms send message starts
                    list<SMS_Outbound_Log__c> checkSMSNotiIds = [select Id, Notification_ID__c from SMS_Outbound_Log__c 
                                                                 where Notification_ID__c =: notiiii];
                    if(checkSMSNotiIds.size() == 0) {
                        getFPTToken(aa.Phone, jsonContent, notiiii);
                    }
                    
                    
                    // zalo send message starts
                    List<Zalo_Outbound_Log_Test__c> checkZaloNotiIds = [select Id, Log__c, Notificaton_Id__c, Time_Editted__c from Zalo_Outbound_Log_Test__c
                                                                     	where Notificaton_Id__c =: notiiii];
                    
                    if(checkZaloNotiIds.size() != 0) {
                        Zalo_Outbound_Log_Test__c checkZaloNotiId = [select Id, Log__c, Notificaton_Id__c, Time_Editted__c from Zalo_Outbound_Log_Test__c
                                                                     where Notificaton_Id__c =: notiiii limit 1];
                        
                        // get account owner and OA token
                        
                        if(checkZaloNotiId.Time_Editted__c != aa.LastModifiedDate) {
                            // update checkZaloNotiId
                            checkZaloNotiId.Time_Editted__c = aa.LastModifiedDate;
                            update checkZaloNotiId;
                            
                            string userId = (string) thisObject.get('OwnerId');
                            Zalo_User_Id__c zid = [select Id, User__c, Zalo_Id__c, Zalo_OA__c 
                                                   from Zalo_User_Id__c where User__c =: userId limit 1];
                            system.debug(zid);
                            Zalo_OA__c zoa = [select Id, OA_Id__c from Zalo_OA__c where Id =: zid.Zalo_OA__c limit 1];
                            
                            sendZaloMessage(aa.Name, zid.Zalo_Id__c, zoa.OA_Id__c, jsonContent, notiiii, 'edited', aa.LastModifiedDate);
                            
                            //
                            
                            List<Zalo_User_Id__c> zids = [select id, Zalo_Id__c, Zalo_OA__c, Account__c	
                                                          from Zalo_User_Id__c
                                                          where Account__c =: accId];
                            for(Zalo_User_Id__c zz : zids) {
                                sendZaloMessage(aa.Name, zz.Zalo_Id__c, zz.Zalo_OA__c, jsonContent, notiiii, 'edited', aa.LastModifiedDate);
                            }
                        }
                        
                    } else {
                        string userId = (string) thisObject.get('OwnerId');
                        Zalo_User_Id__c zid = [select Id, User__c, Zalo_Id__c, Zalo_OA__c 
                                               from Zalo_User_Id__c where User__c =: userId limit 1];
                        system.debug(zid);
                        Zalo_OA__c zoa = [select Id, OA_Id__c from Zalo_OA__c where Id =: zid.Zalo_OA__c limit 1];
                        
                        sendZaloMessage(aa.Name, zid.Zalo_Id__c, zoa.OA_Id__c, jsonContent, (string) notification.get('Id'), 'created', aa.LastModifiedDate);
                    }
                    
                } catch (Exception e) {
					system.debug(e.getMessage());
                    Zalo_Outbound_Log_Test__c zc = new Zalo_Outbound_Log_Test__c();
                    zc.Log__c = e.getMessage();
                    zc.Notificaton_Id__c = 'No notification ID returned';
                    zc.Notificaton__c = 'Failed';
                    insert zc;
                    return e.getMessage();
                }
                
            } else {
                Zalo_Outbound_Log_Test__c zc = new Zalo_Outbound_Log_Test__c();
                zc.Log__c = 'Loser!!!';
                zc.Notificaton_Id__c = 'No notification ID returned';
                zc.Notificaton__c = 'Body is empty.';
                insert zc;
            	system.debug('no response returned');
        	}
        }
        
        /*Zalo_Outbound_Log_Test__c zc = new Zalo_Outbound_Log_Test__c();
        zc.Log__c = 'Here here!!!';
        zc.Notificaton_Id__c = 'No notification ID returned';
        zc.Notificaton__c = 'jsonContent';
        insert zc;*/
        return 'test';
    }
    
    @future(callout=true)
    public static void sendZaloMessage(string namee,string id, string oaid, string jsonContent, string notiId, string msg, datetime edited) {
        // init new zalo log
        Zalo_Outbound_Log_Test__c zc = new Zalo_Outbound_Log_Test__c();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://openapi.zalo.me/v2.0/oa/message?access_token=' + oaid);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"recipient":{"user_id":"' + id + '"},"message":{"text":"Hello, object ' + namee + ' was ' + msg + '. NotiId is: ' + notiId + '.' + '"}}');
        HttpResponse response = http.send(request);
        // Parse the JSON response
        string status = 'Succeed sending to Zalo hoho';
        if (response.getStatusCode() != 201) {
            status = 'Fail sending to Zalo ' + response.getStatusCode() + ' ' + response.getStatus() + ' ' + response.getBody();
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }

        // save zalo log
        
        if(msg == 'created') {
            zc.Notificaton_Id__c = notiId;
        } else {
            zc.Notificaton_Id__c = notiId + ' ' + msg;
        }
        
        zc.Log__c = jsonContent;
        zc.Notificaton__c = status;
        zc.Time_Editted__c = edited;
        insert zc;
    }
    
    public static FPTSMSOAuthResponse getFPTToken(String phone, String jsonContent, String noti) {
        string grantType = 'client_credentials';
        List<FPT_Brand_SMS__c> configs = FPT_Brand_SMS__c.getall().values();
        if(configs.size() == 0) {
            return null;
        }
        
        FPT_Brand_SMS__c config = configs[0];
        string clientId = config.Client_ID__c;
        string clientSecret = config.Client_Secret__c;
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
        sendSMS(result, sessionId, phone, jsonContent, noti);
        return result;
        //return request.getBody();
    }
    
    public static void sendSMS(FPTSMSOAuthResponse token, String sessionId, String phone, String jsonContent, String noti) {
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
        
        SMS_Outbound_Log__c smsLog = new SMS_Outbound_Log__c();
        smsLog.Notification_ID__c = noti;
        smsLog.Log__c = jsonContent;
        smsLog.Notification__c = response.getBody();
        insert smsLog;
    }
}