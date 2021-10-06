@isTest
private class ZaloWebhookTest { // implements HttpCalloutMock {
    
    private class RestMock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"result":"yo"}';

            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest static void doPostTest1() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
                
        //string xml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound"><OrganizationId>00D2w00000CdWQsEAN</OrganizationId><ActionId>04k2w000000L0T1AAK</ActionId><SessionId>00D2w00000CdWQs!ARkAQELsgf3VuJuaG06RQ1WbDGAWcTx4NKMbWNcPzFfX9bp31LApX10._IcGEs9uGsTRCYKENopLGjMPowUqU3iKf4pCNzUB</SessionId><EnterpriseUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/c/50.0/00D2w00000CdWQs</EnterpriseUrl><PartnerUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/u/50.0/00D2w00000CdWQs</PartnerUrl><Notification><Id>04l2w000000gbEiAAI</Id><sObject xsi:type="sf:Account" xmlns:sf="urn:sobject.enterprise.soap.sforce.com"><sf:Id>0012w00000UZVFLAA5</sf:Id><sf:Name>Test Account</sf:Name><sf:Website>fontawesome.com</sf:Website></sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';
        string xml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound"><OrganizationId>00D2w00000CdWQsEAN</OrganizationId><ActionId>04k2w000000L0T1AAK</ActionId><SessionId>00D2w00000CdWQs!ARkAQELsgf3VuJuaG06RQ1WbDGAWcTx4NKMbWNcPzFfX9bp31LApX10._IcGEs9uGsTRCYKENopLGjMPowUqU3iKf4pCNzUB</SessionId><EnterpriseUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/c/50.0/00D2w00000CdWQs</EnterpriseUrl><PartnerUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/u/50.0/00D2w00000CdWQs</PartnerUrl><Notification><Id>04l2w000000gbEiAAI</Id><sObject xsi:type="sf:Account" xmlns:sf="urn:sobject.enterprise.soap.sforce.com"><sf:Id>0012w00000UZVFLAA5</sf:Id><sf:Name>Test Account</sf:Name><sf:Website>fontawesome.com</sf:Website></sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';
        
        request.addHeader('httpMethod', 'POST');
        request.requestUri = '/services/apexrest/zalo/v1/outbound';
        request.requestBody = Blob.valueof(xml);
        RestContext.request = request; 
        RestContext.response= response;
        Test.startTest();
        ZaloWebhook.doPOST();
        Test.stopTest();
    }
    
    @isTest static void doPostTest2() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
                
        string xml = '<response>no</response>';
        
        request.addHeader('httpMethod', 'POST');
        request.requestUri = '/services/apexrest/zalo/v1/outbound';
        request.requestBody = Blob.valueof(xml);
        RestContext.request = request; 
        RestContext.response= response;
        Test.startTest();
        string result = ZaloWebhook.doPOST();
        system.assertEquals('Attempt to de-reference a null object', result);
        Test.stopTest();
    }
    
    @isTest static void doPostTest3() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
                
        string xml = '';
        
        request.addHeader('httpMethod', 'POST');
        request.requestUri = '/services/apexrest/zalo/v1/outbound';
        request.requestBody = Blob.valueof(xml);
        RestContext.request = request; 
        RestContext.response= response;
        Test.startTest();
        ZaloWebhook.doPOST();
        Test.stopTest();
    }
    
    @isTest static void doPostTest4() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
		Account a = new Account(Name = 'test account');
        insert a;
        
        string xml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound"><OrganizationId>00D2w00000CdWQsEAN</OrganizationId><ActionId>04k2w000000L0T1AAK</ActionId><SessionId>00D2w00000CdWQs!ARkAQELsgf3VuJuaG06RQ1WbDGAWcTx4NKMbWNcPzFfX9bp31LApX10._IcGEs9uGsTRCYKENopLGjMPowUqU3iKf4pCNzUB</SessionId><EnterpriseUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/c/50.0/00D2w00000CdWQs</EnterpriseUrl><PartnerUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/u/50.0/00D2w00000CdWQs</PartnerUrl><Notification><Id>0012w00000VJ8U3AAL</Id><sObject xsi:type="sf:Account" xmlns:sf="urn:sobject.enterprise.soap.sforce.com"><sf:Id>' + a.Id + '</sf:Id><sf:Name>Test Account</sf:Name><sf:Website>fontawesome.com</sf:Website></sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';
        
        request.addHeader('httpMethod', 'POST');
        request.requestUri = '/services/apexrest/zalo/v1/outbound';
        request.requestBody = Blob.valueof(xml);
        RestContext.request = request; 
        RestContext.response= response;
        Test.startTest();
        ZaloWebhook.doPOST();
        Test.stopTest();
        Zalo_Outbound_Log_Test__c checkZaloNotiId = [select Id, Log__c, Notificaton_Id__c, Time_Editted__c 
                                                     from Zalo_Outbound_Log_Test__c 
                                                     limit 1];
        //Zalo_Outbound_Log_Test__c ccc = new Zalo_Outbound_Log_Test__c();
        system.assertEquals('List has no rows for assignment to SObject', checkZaloNotiId.Log__c);
    }
    
    @isTest static void doPostTest5() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
		Account a = new Account(Name = 'test account');
        insert a;
        
        string xml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound"><OrganizationId>00D2w00000CdWQsEAN</OrganizationId><ActionId>04k2w000000L0T1AAK</ActionId><SessionId>00D2w00000CdWQs!ARkAQELsgf3VuJuaG06RQ1WbDGAWcTx4NKMbWNcPzFfX9bp31LApX10._IcGEs9uGsTRCYKENopLGjMPowUqU3iKf4pCNzUB</SessionId><EnterpriseUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/c/50.0/00D2w00000CdWQs</EnterpriseUrl><PartnerUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/u/50.0/00D2w00000CdWQs</PartnerUrl><Notification><Id>0012w00000VJ8U3AAL</Id><sObject xsi:type="sf:Account" xmlns:sf="urn:sobject.enterprise.soap.sforce.com"><sf:Id>a0I2w000000SUhwEAG</sf:Id><sf:Name>Test Account</sf:Name><sf:Website>fontawesome.com</sf:Website></sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';
        
        request.addHeader('httpMethod', 'POST');
        request.requestUri = '/services/apexrest/zalo/v1/outbound';
        request.requestBody = Blob.valueof(xml);
        RestContext.request = request; 
        RestContext.response= response;
        Test.startTest();
        ZaloWebhook.doPOST();
        Test.stopTest();
        Zalo_Outbound_Log_Test__c checkZaloNotiId = [select Id, Log__c, Notificaton_Id__c, Time_Editted__c 
                                                     from Zalo_Outbound_Log_Test__c 
                                                     limit 1];
        //Zalo_Outbound_Log_Test__c ccc = new Zalo_Outbound_Log_Test__c();
        system.assertEquals('List has no rows for assignment to SObject', checkZaloNotiId.Log__c);
    }
    
    @isTest static void sendZaloMessageTest1() {
        string id = 'testid1';
        string oaid = 'testid2';
        Datetime myDateTime = Datetime.newInstance(1998, 3, 30);
        Test.setMock(HttpCalloutMock.class, new RestMock());
        
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse(); 
        
        string xml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound"><OrganizationId>00D2w00000CdWQsEAN</OrganizationId><ActionId>04k2w000000L0T1AAK</ActionId><SessionId>00D2w00000CdWQs!ARkAQELsgf3VuJuaG06RQ1WbDGAWcTx4NKMbWNcPzFfX9bp31LApX10._IcGEs9uGsTRCYKENopLGjMPowUqU3iKf4pCNzUB</SessionId><EnterpriseUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/c/50.0/00D2w00000CdWQs</EnterpriseUrl><PartnerUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/u/50.0/00D2w00000CdWQs</PartnerUrl><Notification><Id>04l2w000000gbEiAAI</Id><sObject xsi:type="sf:Account" xmlns:sf="urn:sobject.enterprise.soap.sforce.com"><sf:Id>0012w00000UZVFLAA5</sf:Id><sf:Name>Test Account</sf:Name><sf:Website>fontawesome.com</sf:Website></sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';
        
        request.addHeader('httpMethod', 'POST');
        request.requestUri = '/services/apexrest/zalo/v1/outbound';
        request.requestBody = Blob.valueof(xml);
        RestContext.request = request; 
        RestContext.response= response;
        
        Test.startTest();
        ZaloWebhook.sendZaloMessage('Account name', id, oaid, 'jsoncontent', id, 'message here', myDateTime);
        Test.stopTest();
    }
    
    @isTest static void sendZaloMessageTest3() {
        string id = 'testid1';
        string oaid = 'testid2';
        Datetime myDateTime = Datetime.newInstance(1998, 3, 30);
        Test.setMock(HttpCalloutMock.class, new RestMock());
        
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse(); 
        
        string xml = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><notifications xmlns="http://soap.sforce.com/2005/09/outbound"><OrganizationId>00D2w00000CdWQsEAN</OrganizationId><ActionId>04k2w000000L0T1AAK</ActionId><SessionId>00D2w00000CdWQs!ARkAQELsgf3VuJuaG06RQ1WbDGAWcTx4NKMbWNcPzFfX9bp31LApX10._IcGEs9uGsTRCYKENopLGjMPowUqU3iKf4pCNzUB</SessionId><EnterpriseUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/c/50.0/00D2w00000CdWQs</EnterpriseUrl><PartnerUrl>https://wikicanvasart-dev-ed.my.salesforce.com/services/Soap/u/50.0/00D2w00000CdWQs</PartnerUrl><Notification><Id>04l2w000000gbEiAAI</Id><sObject xsi:type="sf:Account" xmlns:sf="urn:sobject.enterprise.soap.sforce.com"><sf:Id>0012w00000UZVFLAA5</sf:Id><sf:Name>Test Account</sf:Name><sf:Website>fontawesome.com</sf:Website></sObject></Notification></notifications></soapenv:Body></soapenv:Envelope>';
        
        request.addHeader('httpMethod', 'POST');
        request.requestUri = '/services/apexrest/zalo/v1/outbound';
        request.requestBody = Blob.valueof(xml);
        RestContext.request = request; 
        RestContext.response= response;
        
        Test.startTest();
        ZaloWebhook.sendZaloMessage('Account name', id, oaid, 'jsoncontent', id, 'created', myDateTime);
        Test.stopTest();
    }
}