@RestResource(urlMapping ='/students/*')
global class StudentsRestService {
   
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

        public List<StudentWrapper> getStudentWrapperList(List<Student__c> studentsList){

            List<StudentWrapper> studentsToSerializeList = new List<StudentWrapper>();
            for(Student__c student_i : studentsList){
                studentsToSerializeList.add(new StudentWrapper(student_i));
            }
            return studentsToSerializeList;
        }
    }

    // Example /services/apexrest/students/84E
    @HttpGet
    global static void getStudents(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        StudentWrapper wrapper = new StudentWrapper();
        String groupName = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try{
            List<Student__c> studentsList = [SELECT Active__c, Group__c, Phone_Number__c, Student_Email__c, Student_Name__c, Student_Surname__c
                                            FROM Student__c
                                            WHERE Group__r.Name = :groupName];

            res.statuscode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(wrapper.getStudentWrapperList(studentsList)));
        } catch(Exception e){
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(e.getMessage());
        }
    }
    // Example /services/apexrest/students + {"surname":"Petrenko","name":"Petro","groupId":"a027Q000003HgD8QAK","email":"test@test.com","active":true}
    // GroupId = null triggers dmlexception
    @HttpPost
    global static void postStudent(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String requestBody = req.requestBody.toString();
        StudentWrapper student = (StudentWrapper) JSON.deserialize(requestBody, StudentWrapper.class);
        try{
            Student__c studentToInsert = new Student__c(Group__c = student.groupId, 
                                                        Active__c = student.active,
                                                        Phone_Number__c = student.phone,
                                                        Student_Email__c = student.email,
                                                        Student_Name__c = student.name,
                                                        Student_Surname__c = student.surname);
            insert studentToInsert;
            res.statuscode = 200;
            res.responseBody = Blob.valueOf('Student was inserted with id ' + studentToInsert.Id);
        }catch(DmlException e){
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(e.getMessage());
        }

    }
    
    // Example /services/apexrest/students/a007Q00000BYMVLQA5 
    // {"surname":"Petrenko","name":"Semen","groupId":"a027Q000003HgD8QAK","email":"testUpdate@test.com","active":false, "phone":"+380584321349"}
    @HttpPatch
    global static void patchStudent(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String studentId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        String requestBody = req.requestBody.toString();
        StudentWrapper student = (StudentWrapper) JSON.deserialize(requestBody, StudentWrapper.class);
        try{
            Student__c studentToUpdate = new Student__c(Id = studentId,
                                                        Group__c = student.groupId, 
                                                        Active__c = student.active,
                                                        Phone_Number__c = student.phone,
                                                        Student_Email__c = student.email,
                                                        Student_Name__c = student.name,
                                                        Student_Surname__c = student.surname);
            update studentToUpdate;
            res.statuscode = 200;
            res.responseBody = Blob.valueOf('Student was updated');
        } catch (DmlException e){
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(e.getMessage());
        }

    }

    // Example /services/apexrest/students/a007Q00000BYIweQAH
    @HttpDelete
    global static void deleteStudent(){

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String studentId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try{
            Student__c student = [SELECT Id 
                                FROM Student__c
                                WHERE Id = :studentId];
            delete student;
            res.statuscode = 200;
            res.responseBody = Blob.valueOf('Student was deleted');
        } catch(DmlException e){
            res.statuscode = 400;
            res.responseBody = Blob.valueOf(e.getMessage());
        }
    }

}
