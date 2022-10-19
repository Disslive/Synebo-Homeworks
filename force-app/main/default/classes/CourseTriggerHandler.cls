public with sharing class CourseTriggerHandler {

    public void changeNegativeNumber(List<Course__c> newCourses) {

        for(Course__c course : newCourses){
            if(course.Hours__c < 0){
                course.Hours__c *= -1;
            } else if(course.Hours__c == 0){
                course.Hours__c = 100;
            }

            if(course.Task_Number__c < 0){
                course.Task_Number__c *= -1;
            } else if(course.Task_Number__c == 0){
                course.Task_Number__c = 16;
            }

        }

    }
}
