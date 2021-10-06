@isTest 
private class testContactAvatarAttachmentController {
	@isTest static void testUpdatePicturePath() {
        //create and get first contact
        Contact sample = new Contact(LastName = 'John');
        insert sample;
        Contact c1 = [SELECT Id, Avatar__c FROM Contact LIMIT 1];
        
        //Create Document
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.jpg';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Documents
		Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        
        //create and get ContentDocumentLink
        ContentDocumentLink cd = new ContentDocumentLink(LinkedEntityId = c1.Id, ContentDocumentId = conDocId);
        insert cd;
        
		ContactAvatarAttachmentController.updatePicturePath(c1.Id);    
        System.assertNotEquals('', c1.Avatar__c);
    }
}