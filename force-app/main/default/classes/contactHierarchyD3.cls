public with sharing class contactHierarchyD3 {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String id){
        return [SELECT Id, AccountId, Name, Title, Phone, ReportsToId 
                FROM Contact 
                WHERE AccountId =: id
                WITH SECURITY_ENFORCED];
    }
}