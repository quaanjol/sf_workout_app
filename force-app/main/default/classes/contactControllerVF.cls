public class contactControllerVF {
    @RemoteAction
    public static List<Contact> getContacts(string accountId) {
        return [SELECT Id, Name, Email, AccountId, Title, Avatar__c, ReportsToId FROM Contact WHERE AccountId =: accountId];
    }
    
    @RemoteAction
    public static Contact updateDrag(string dragId, string selectId) {
        Contact dragged = [select Id, Name, ReportsToId from Contact where Id =: dragId limit 1];
        dragged.ReportsToId = selectId;
        update dragged;
        return dragged;
    }
}