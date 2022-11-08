public with sharing class StudentTriggerHandler {

    public void calculateStudentsCount(List<Student__c> newStudentsList, Map<Id, Student__c> oldStudentsMap){
        Set<Id> groupIds = new Set<Id>();
        Map<Id, Integer> departmentStudentsMap = new Map<Id, Integer>();
        List<Student__c> countingList;
        List<Department__c> departmentsToUpdateList = new List<Department__c>();

        if(newStudentsList == null){
            countingList = getActiveStudents(oldStudentsMap.values());
        } else if(oldStudentsMap == null){
            countingList = getActiveStudents(newStudentsList);
        } 

        for(Student__c student_i : countingList){
            groupIds.add(student_i.Group__c);
        }
        
        Map<Id, Group__c> groupsMap = new Map<Id, Group__c> ([SELECT Id, Department__c, Department__r.Total_Students__c 
                                                            FROM Group__c  
                                                            WHERE Id IN :groupIds]);
        Map<Id, Integer> oldDepartmentStudentsMap = new Map<Id, Integer>();

        for(Id groupKey : groupsMap.keySet()){
            Group__c groupValue = groupsMap.get(groupKey);
            oldDepartmentStudentsMap.put(groupValue.Department__c, (Integer)groupValue.Department__r.Total_Students__c);
        }

        //If insert - counter is (1), if delete - counter is (-1)
        for(Student__c student_i : countingList){

            Group__c returnedGroup = groupsMap.get(student_i.Group__c);
            if(newStudentsList == null){

                returnedGroup.Department__r.Total_Students__c -=1;
            } else if(oldStudentsMap == null){

                returnedGroup.Department__r.Total_Students__c +=1;
            } 
            departmentStudentsMap.put(returnedGroup.Department__c, (Integer)returnedGroup.Department__r.Total_Students__c);
        }
        //Compare old values with new ones and if they changed add to updating list
        
        for(Id key : oldDepartmentStudentsMap.keySet()){

            Integer OldStudentsAmount = oldDepartmentStudentsMap.get(key);
            Integer calculatedStudentsAmount = departmentStudentsMap.get(key);
            if(OldStudentsAmount != calculatedStudentsAmount){

                departmentsToUpdateList.add(new Department__c(Id = key, Total_Students__c = calculatedStudentsAmount));
            }
        }

        if(!departmentsToUpdateList.isEmpty()){
            update departmentsToUpdateList;
        }
    }

    public void calculateUpdatedStudents(List<Student__c> newStudentsList, Map<Id, Student__c> oldStudentsMap){
       
        Set<Id> groupIds = new Set<Id>();
        Set<Id> departmentIds = new Set<Id>();
        for(Student__c student_i : newStudentsList){
            if(student_i.Active__c != oldStudentsMap.get(student_i.Id).Active__c){
                groupIds.add(student_i.Group__c);
            }
        }
        List<Group__c> groupsMap =[SELECT Id, Department__c
                                   FROM Group__c  
                                   WHERE Id IN :groupIds];
        
        for(Group__c group_i : groupsMap){
            departmentIds.add(group_i.Department__c);
        }
        if(!departmentIds.isEmpty()){
            updateDepartmentStudentsCount(departmentIds);
        }

    }

    @future
    private static void updateDepartmentStudentsCount(Set<Id> departmentIds){

        List<Department__c> departmentsToUpdateList = new List<Department__c>();
        Map<Id, AggregateResult> studentsCountMap =  new Map<Id,AggregateResult>([SELECT Group__r.Department__c Id, COUNT(Id) totalStudents, MAX(Group__r.Department__r.Total_Students__c) oldCount
                                                                                FROM Student__c 
                                                                                WHERE Active__c = true AND Group__r.Department__c IN :departmentIds
                                                                                GROUP BY Group__r.Department__c]);

        for(Id depId : departmentIds){
            Integer newCount = 0;
            Integer oldCount = 0;
            AggregateResult aggrResult = studentsCountMap.get(depId);
            if(aggrResult != null){
                newCount = Integer.valueOf(aggrResult.get('totalStudents'));
                oldCount = Integer.valueOf(aggrResult.get('oldCount'));
            }
            
            if(newCount!=oldCount || newCount == 0){
                departmentsToUpdateList.add(new Department__c(Id = depId, Total_Students__c = newCount));
            }
        }
        if(!departmentsToUpdateList.isEmpty()){
            update departmentsToUpdateList;
        }
    }

    private List<Student__c> getActiveStudents(List<Student__c> allStudentsList){

        List<Student__c> activeStudentsList = new List<Student__c>();
        for(Student__c student_i : allStudentsList){
            if(student_i.Active__c == true){
                activeStudentsList.add(student_i);
            }
        }
        return activeStudentsList;
    }


}