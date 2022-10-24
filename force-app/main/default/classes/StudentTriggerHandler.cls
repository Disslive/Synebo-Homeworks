public with sharing class StudentTriggerHandler {

    public void calculateStudentsCount(List<Student__c> newStudentsList, Map<Id, Student__c> oldStudentsMap){
        Set<Id> groupIds = new Set<Id>();
        Map<Id, Integer> departmentStudentsMap = new Map<Id, Integer>();
        List<Student__c> countingList = newStudentsList;
        List<Department__c> departmentsToUpdateList = new List<Department__c>();
        if(newStudentsList == null){
            countingList = oldStudentsMap.values();
        }

        for(Student__c student_i : countingList){
            groupIds.add(student_i.Group__c);
        }
        
        Map<Id, Group__c> groupsMap = new Map<Id, Group__c> ([SELECT Id, Department__c, Department__r.Total_Students__c 
                                                            FROM Group__c  
                                                            WHERE Id IN :groupIds]);
        Map<Id, Department__c> oldDepartmentStudentsMap = new Map<Id, Department__c>([SELECT Id, Total_Students__c 
                                                                                    FROM Department__c 
                                                                                    WHERE Id IN (SELECT Department__c 
                                                                                                FROM Group__c 
                                                                                                WHERE Id IN :groupIds)]);
        //If Active__c become false or record is deleted counter is (-1), if inserting or Active__c becoming true counter is (1)
        for(Student__c student_i : countingList){

            Group__c returnedGroup= groupsMap.get(student_i.Group__c);
            if(newStudentsList == null && student_i.Active__c == true){
                
                returnedGroup.Department__r.Total_Students__c -=1;
            } else if(oldStudentsMap == null && student_i.Active__c == true){

                returnedGroup.Department__r.Total_Students__c +=1;
            } else{
                if(student_i.Active__c != oldStudentsMap.get(student_i.Id).Active__c){
                    if(student_i.Active__c == true){
                        returnedGroup.Department__r.Total_Students__c +=1;
                    } else {
                        returnedGroup.Department__r.Total_Students__c -=1;
                    }
                }
            }

            groupsMap.put(student_i.Group__c, returnedGroup);
            departmentStudentsMap.put(returnedGroup.Department__c, (Integer)returnedGroup.Department__r.Total_Students__c);
        }
        //Compare old values with new ones and if they changed add to updating list
        for(Id key : oldDepartmentStudentsMap.keySet()){

            Department__c department = oldDepartmentStudentsMap.get(key);
            Integer calculatedStudentsAmount = departmentStudentsMap.get(key);
            if(department.Total_Students__c != calculatedStudentsAmount){

                department.Total_Students__c = calculatedStudentsAmount;
                departmentsToUpdateList.add(department);
            }
        }

        if(!departmentsToUpdateList.isEmpty()){
            update departmentsToUpdateList;
        }
    }

}