public with sharing class StudentTriggerHandler {

    public void calculateStudentsCount(List<Student__c> newStudents, String operationType){
        Set<Department__c> departments = new Set<Department__c>();
        Set<Id> groupIds = new Set<Id>();
        Integer counter;
        for(Student__c student_i : newStudents){
            groupIds.add(student_i.Group__c);
        }
        
        List<Group__c> groupsList = [SELECT Id, Department__c, Department__r.Total_Students__c FROM Group__c WHERE Id IN :groupIds];

        if(operationType.contains('DELETE')){
            counter = -1;
        } else{
            counter = 1;
        }

        for(Student__c student_i : newStudents){
            for(Group__c group_i : groupsList){
                if(student_i.Group__c == group_i.Id){
                    group_i.Department__r.Total_Students__c +=counter;
                }
            }
        }

        for(Group__c group_i : groupsList){
            departments.add(new Department__c(Id = group_i.Department__c, Total_Students__c = group_i.Department__r.Total_Students__c));
        }
        List<Department__c> departmentsList = new List<Department__c>();
        departmentsList.addAll(departments);
        update departmentsList;

    }

}
