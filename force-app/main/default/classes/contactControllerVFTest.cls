@isTest
private class contactControllerVFTest {
    @isTest static void getContactsTest() {
        Account aa = new Account (Name = 'Loriver Carpet');
        insert aa;
        
        Contact c = new Contact (LastName = 'Le', FirstName = 'Minh Quan', Title = 'CEO', AccountId = aa.Id);
        insert c;
        Contact cc = new Contact (LastName = 'Le', FirstName = 'Minh Quyen', Title = 'developer', ReportsToId = c.Id, AccountId = aa.Id);
        insert cc;
        
        List<Contact> results = contactControllerVF.getContacts(aa.Id);
    }
    
    @isTest static void updateDragTest() {
        Account aa = new Account (Name = 'Loriver Carpet');
        insert aa;
        
        Contact c = new Contact (LastName = 'Le', FirstName = 'Minh Quan', Title = 'CEO', AccountId = aa.Id);
        insert c;
        Contact cc = new Contact (LastName = 'Le', FirstName = 'Minh Quyen', Title = 'developer', AccountId = aa.Id);
        insert cc;
        
		contactControllerVF.updateDrag(cc.Id, c.Id);
		//system.assertEquals(cc.ReportsToId, c.Id);
    }
}