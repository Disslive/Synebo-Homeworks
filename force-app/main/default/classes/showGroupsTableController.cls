public with sharing class showGroupsTableController {
    
    @AuraEnabled(cacheable=true)
    public static Response getGroups(Id departmentId){
        Response resp;
        try {
            List<Group__c> groupsList = [SELECT Id, Name, Students_Amount__c, Education_year__c, Education_Form__c, Curator__r.Teacher_Name__c
                                        FROM Group__c
                                        WHERE Department__c = :departmentId];

            resp = new Response(groupsList);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
}
