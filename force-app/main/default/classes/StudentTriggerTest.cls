@isTest
public class StudentTriggerTest {

    @TestSetup
    public static void setup(){
        List<Department__c> departments = TestDataFactory.getDepartmetList(2);
        List<Group__c> groups = new List<Group__c>();
        List<Student__c> students = new List<Student__c>();
        insert departments;

        for(Department__c dep_i : departments){
            groups.addAll(TestDataFactory.getGroupsForDepartment(dep_i.Id, 2));
        }
        insert groups;

        for(Group__c group_i : groups){
            students.addAll(TestDataFactory.getStudentsForGroup(group_i.Id, 30));
        }
        insert students;
    }

    @isTest 
    public static void calculateStudentsCountInsertTest(){
        
        List<Group__c> groupsList = [SELECT Id, Department__c, Department__r.Total_Students__c
                                    FROM Group__c];
        List<Student__c> studentsToInsert = new List<Student__c>();
        Map<Id, Integer> oldStudentsCountMap = new Map<Id,Integer>();

        for(Group__c group_i : groupsList){
            oldStudentsCountMap.put(group_i.Department__c, (Integer)group_i.Department__r.Total_Students__c);
            studentsToInsert.addAll(TestDataFactory.getStudentsForGroup(group_i.Id, 50));
        }

        test.startTest();
        insert studentsToInsert;
        test.stopTest();
        
        List<Department__c> departmentsAfterInsert = [SELECT Id, Total_Students__c
                                                    FROM Department__c];

        System.assertEquals(oldStudentsCountMap.get(departmentsAfterInsert[0].Id) + 50, departmentsAfterInsert[0].Total_Students__c, 'Calculating error in inserting 1 department students');
        System.assertEquals(oldStudentsCountMap.get(departmentsAfterInsert[1].Id) + 50, departmentsAfterInsert[1].Total_Students__c, 'Calculating error in inserting 2 department students');
    }

    @isTest 
    public static void calculateStudentsCountDeleteTest(){

        Department__c dep = [SELECT Id, Total_Students__c
                            FROM Department__c
                            LIMIT 1];
        
        List<Student__c> studentsToDeleteList = [SELECT Id, Active__c
                                                FROM Student__c
                                                WHERE Group__r.Department__c = :dep.Id
                                                LIMIT 30];
        Integer activeCount = 0;
        for(Student__c student_i : studentsToDeleteList){

            if(student_i.Active__c == true){
                activeCount+=1;
            }
        }
        
        test.startTest();
        delete studentsToDeleteList;
        test.stopTest();
        Department__c depAfterDelete = [SELECT Id, Total_Students__c
                                        FROM Department__c
                                        WHERE Id = :dep.Id];
        System.assertEquals(dep.Total_Students__c - activeCount, depAfterDelete.Total_Students__c, 'Calculating error after deleting records');
    }

    @isTest 
    public static void calculateStudentsCountUpdateTest(){

        Department__c dep = [SELECT Id, Total_Students__c
        FROM Department__c
        LIMIT 1];

        List<Student__c> studentsToUpdateList = [SELECT Id, Active__c
                                                FROM Student__c
                                                WHERE Group__r.Department__c = :dep.Id
                                                LIMIT 31];
        Integer activeCount = 0;
        for(Student__c student_i : studentsToUpdateList){

            if(student_i.Active__c == true){
                student_i.Active__c = false;
                activeCount-=1;
            } else {
                student_i.Active__c = true;
                activeCount+=1;
            }
        }

        test.startTest();
        update studentsToUpdateList;
        test.stopTest();

        Department__c depAfterUpdate = [SELECT Id, Total_Students__c
                                        FROM Department__c
                                        WHERE Id = :dep.Id];
        System.assertEquals(dep.Total_Students__c + activeCount, depAfterUpdate.Total_Students__c, 'Calculating error after updating records');

    }
}