/*@RestResource(urlMapping='/twilio/v1/webhook')*/
global class TwilioWebhookQuan {
	/*@HttpPOST*/
    global static String doPOST() {
        /*RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Account> result = [SELECT Id, Name, Phone, Website FROM Account];*/
        
        //SoftphoneProviderHelper spph = new SoftphoneProviderHelper();
        //SoftphoneProviderHelper.TwilioProvider tp = new SoftphoneProviderHelper.TwilioProvider();
        //SoftphoneProviderHelper.CallResult result = tp.makeCall('ACf1e7d1b68c82cc3cbca255b4b8fbd5c8', 'b01bf8dbe48db63f5cfb236cf6aef2f5', '84338566226', '+12056248839');
        
        /*if(RestContext.request.params != null){
            if (RestContext.request.params.toString() != '') {
                try {
                    Twilio_Call_Log__c TCLog = new Twilio_Call_Log__c(Log__c = RestContext.request.params.toString());
                    insert TCLog;
                    return String.valueOf(RestContext.request.params.toString());
                } catch (Exception e) {
                    return e.getMessage();
                }
            } else {
            	Twilio_Call_Log__c TCLog = new Twilio_Call_Log__c(Log__c = 'test');
            	insert TCLog;
            	return 'test';
        	}
        }*/
        return 'test';
    }
}