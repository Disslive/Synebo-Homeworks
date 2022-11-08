public with sharing class insertDepartmentController {
    
    @AuraEnabled
    public static Response insertDepartment(String name, String description, String email, String phone){
        Response resp;
        try {
            Department__c dep = new Department__c(Name = name, 
                                                Description__c = description,
                                                Email__c = email,
                                                Phone_Number__c = phone);

            insert dep;
            resp = new Response(dep);
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
}
