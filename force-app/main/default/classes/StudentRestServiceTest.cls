@isTest
public class StudentRestServiceTest {
    
    private class StudentWrapper{
        Boolean active;
        String phone;
        String email;
        String groupId;
        String name;
        String surname;

        StudentWrapper(){

        }
        StudentWrapper(Student__c student){

            this.groupId = student.Group__c;
            this.active = student.Active__c;
            this.phone = student.Phone_Number__c;
            this.email = student.Student_Email__c;
            this.name = student.Student_Name__c;
            this.surname = student.Student_Surname__c;
        }
    }

    @TestSetup
    public static void setup(){
        Department__c department = TestDataFactory.getDepartment('Economic');
        insert department;
        Group__c newGroup = TestDataFactory.getGroup(department.Id, '84E');
        insert newGroup;
        List<Student__c> students = TestDataFactory.getStudentsForGroup(newGroup.Id, 50);
        insert students;
    }

    @isTest
    static private void getStudentsPostitiveTest(){

        Group__c selectedGroup = [SELECT Id, Name
                        FROM Group__c
                        LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/students/' + selectedGroup.Name;
        request.httpMethod = 'GET';
        
        request.addHeader('Content-Type', 'application/json');

        RestContext.request = request;
        RestContext.response = response;
        Test.startTest();
        StudentsRestService.getStudents();
        Test.stopTest();

        List<StudentWrapper> responseBodyList = (List<StudentWrapper>)JSON.deserialize(response.responseBody.toString(), List<StudentWrapper>.class);
        System.assertEquals(50, responseBodyList.size(), 'Records weren`t received');
    }

    @isTest
    static private void getStudentsNegativeTest(){

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.requestURI = '/services/apexrest/students/2323423';
        request.httpMethod = 'GET';
        
        request.addHeader('Content-Type', 'application/json');

        RestContext.request = request;
        RestContext.response = response;
        Test.startTest();
        StudentsRestService.getStudents();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'No errors');
    }


    @isTest
    static private void postStudentPositiveTest(){

        Group__c selectedGroup = [SELECT Id, Name
                        FROM Group__c
                        LIMIT 1];

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        StudentWrapper student = new StudentWrapper();
        student.groupId = selectedGroup.Id;
        student.name = 'Test';
        student.active = true;

        request.requestURI = '/services/apexrest/students/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(JSON.serialize(student));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        StudentsRestService.postStudent();
        Test.stopTest();

        Student__c postedStudent = [SELECT Id, Student_Name__c
                                    FROM Student__c
                                    WHERE Student_Name__c = :student.name];
        String resBody = response.responseBody.toString();
        System.assertEquals(postedStudent.Id, resBody, 'Record wasn`t posted'); 
    }

    @isTest
    static private void postStudentNegativeTest(){

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        StudentWrapper student = new StudentWrapper();
        student.name = 'Test';
        student.active = true;

        request.requestURI = '/services/apexrest/students/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(JSON.serialize(student));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        StudentsRestService.postStudent();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'No errors');
    }

    @isTest
    static private void patchStudentPositiveTest(){

        Student__c student = [SELECT Id, Student_Name__c, Student_Surname__c, Group__c, Active__c, Phone_Number__c, Student_Email__c
                            FROM Student__c
                            LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        StudentWrapper wrapper = new StudentWrapper(student);
        wrapper.name = 'New Name';
        wrapper.surname = 'New Surname';

        request.requestURI = '/services/apexrest/students/' + student.Id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(JSON.serialize(wrapper));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        StudentsRestService.patchStudent();
        Test.stopTest();

        Student__c studentAfterPatch = [SELECT Id, Student_Name__c, Student_Surname__c
                                        FROM Student__c
                                        WHERE Id = :student.Id];

        System.assertEquals('New Name', studentAfterPatch.Student_Name__c, 'Record wasn`t patched'); 
        System.assertEquals('New Surname', studentAfterPatch.Student_Surname__c, 'Record wasn`t patched'); 
    }

    @isTest
    static private void patchStudentNegativeTest(){

        Student__c student = [SELECT Id, Student_Name__c, Student_Surname__c, Group__c, Active__c, Phone_Number__c, Student_Email__c
                            FROM Student__c
                            LIMIT 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        StudentWrapper wrapper = new StudentWrapper(student);
        wrapper.name = 'New Name';
        wrapper.surname = 'New Surname';
        wrapper.groupId = '21144';

        request.requestURI = '/services/apexrest/students/' + student.Id;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(JSON.serialize(wrapper));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        StudentsRestService.patchStudent();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'No errors');
    }

    @isTest
    static private void deleteStudentPositiveTest(){

        Student__c student = [SELECT Id, Student_Name__c, Student_Surname__c, Group__c, Active__c, Phone_Number__c, Student_Email__c
                            FROM Student__c
                            LIMIT 1];

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestURI = '/services/apexrest/students/' + student.Id;
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        StudentsRestService.deleteStudent();
        Test.stopTest();

        String resBody = response.responseBody.toString();
        System.assertEquals('Student was deleted', resBody, 'Record wasn`t deleted'); 
    }

    @isTest
    static private void deleteStudentNegativeTest(){

        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();

        request.requestURI = '/services/apexrest/students/' + '2222';
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        
        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        StudentsRestService.deleteStudent();
        Test.stopTest();

        System.assertEquals(400, response.statusCode, 'No errors');
    }

}