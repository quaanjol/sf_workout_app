@RestResource(urlMapping='/twilio/v1/webhook')
global class CaresoftWebhook {
	@HttpPOST
    global static String doPOST() {
        if(RestContext.request != null){
            if (RestContext.request.toString() != '') {
                try {
                    Caresoft_Call_Log_Api__c CCLog = new Caresoft_Call_Log_Api__c(Log__c = RestContext.request.toString());
                    insert CCLog;
                    return String.valueOf(RestContext.request.toString());
                } catch (Exception e) {
                    return e.getMessage();
                }
            } else {
            	Caresoft_Call_Log_Api__c CCLog = new Caresoft_Call_Log_Api__c(Log__c = 'test');
            	insert CCLog;
            	return 'test';
        	}
        }
        return 'test';
    }
}