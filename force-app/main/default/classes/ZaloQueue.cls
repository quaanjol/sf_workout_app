public class ZaloQueue implements Queueable, Database.AllowsCallouts {
    public void execute (QueueableContext context) {
        Zalo_Outbound_Log_Test__c zc = new Zalo_Outbound_Log_Test__c();
        zc.Log__c = 'TaiHT Loser!!!';
        zc.Notificaton_Id__c = 'No notification ID returned';
        zc.Notificaton__c = 'jsonContent';
        insert zc;
    }
    
    @future(callout=true)
    public static void sendZaloMessage(string id, string oaid, string jsonContent, string notiId) {
        // init new zalo log
        Zalo_Outbound_Log_Test__c zc = new Zalo_Outbound_Log_Test__c();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://openapi.zalo.me/v2.0/oa/message?access_token=' + oaid);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"recipient":{"user_id":"' + id + '"},"message":{"text":"Hello, New Test Account created"}}');
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
        zc.Log__c = jsonContent;
        zc.Notificaton_Id__c = notiId;
        zc.Notificaton__c = status;
        insert zc;
    }
}