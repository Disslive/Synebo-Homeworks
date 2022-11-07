public class TestDataFactory {
   
    public static Department__c getDepartment(String depName){
        return new Department__c(Name = depName, Total_Students__c = 0);
    }

    public static Group__c getGroup(Id depId, String groupName){
        return new Group__c(Department__c = depId, Name = groupName);
    }

    public static Student__c getStudent(Id groupId, Boolean active){
        return new Student__c(Group__c = groupId, Active__c = active);
    }

    public static List<Department__c> getDepartmetList(Integer depsNum){
        
        List<Department__c> departmentsList = new List<Department__c>();
        for(Integer i = 0; i < depsNum; i++){

            departmentsList.add(getDepartment('Department' + i));
        }
        return departmentsList;
    }
    
    public static List<Group__c> getGroupsForDepartment(Id depId, Integer groupsNum){

        List<Group__c> groupsList = new List<Group__c>();
        for(Integer i = 0; i < groupsNum; i++){

            groupsList.add(getGroup(depId, 'Group' + i));
        }
        return groupsList;
    }

    public static List<Student__c> getStudentsForGroup(Id groupId, Integer studentsNum){

        List<Student__c> studentsList = new List<Student__c>();
        Boolean active;
        for(Integer i = 0; i < studentsNum; i++){

            if(math.mod(i,2) == 0){
                active = true;
            } else{
                active = false;
            }
            studentsList.add(getStudent(groupId, active));
        }
        return studentsList;
    }

}
