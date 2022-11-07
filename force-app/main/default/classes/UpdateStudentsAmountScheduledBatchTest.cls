@isTest
public class UpdateStudentsAmountScheduledBatchTest {
    
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
    private static void TotalStudentsBatchTest(){

        Test.startTest();
        Id batchId = Database.executeBatch(new UpdateStudentsAmountScheduledBatch());
        Test.stopTest();

        List<Department__c> departments = [SELECT Id, Total_Students__c
                                            FROM Department__c];
        System.assertEquals(30, departments[0].Total_Students__c, 'Wrong total students calculation for 1 department');
        System.assertEquals(30, departments[1].Total_Students__c, 'Wrong total students calculation for 2 department');
    }

    @isTest
    private static void SchedulerTest(){
        String CRON_EXP = '0 0 6 * * ? *';
        Date tomorrowDate = Date.today().addDays(1);
        Datetime expectedDatetime = Datetime.newInstance(tomorrowDate.year(), tomorrowDate.month(), tomorrowDate.day(), 6, 0, 0);
        Test.startTest();
        String jobId = System.schedule('Recalculate total students count', CRON_EXP, new UpdateStudentsAmountScheduledBatch());
        Test.stopTest();
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(expectedDatetime, ct.NextFireTime, 'Scheduler wasn`t started');   
    }

}
