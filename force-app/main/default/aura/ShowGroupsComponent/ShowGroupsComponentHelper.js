({
    fetchGroups : function(component) {

        component.set("v.columns",[
            { label: 'Group Name', fieldName: 'Name' },
            { label: 'Students Amount', fieldName: 'Students_Amount__c', type: 'number' },
            { label: 'Education Year', fieldName: 'Education_year__c', type: 'number' },
            { label: 'Education Form', fieldName: 'Education_Form__c', type: 'text' },
            { label: 'Curator', fieldName: 'Teacher_Name__c'},
        ]);

        var getGroups = component.get("c.getGroups");

        getGroups.setParams({
            departmentId: component.get("v.recordId")
        });
        
        getGroups.setCallback(this, function(data){

            var result = data.getReturnValue();
            if(result.isSuccess){

                for(var i = 0; i< result.responseObj.length; i++){
                    var row = result.responseObj[i];
                    if(row.Curator__r) row.Teacher_Name__c = row.Curator__r.Teacher_Name__c;
                }
                component.set("v.rows", result.responseObj);
                component.set("v.error", undefined);
            } else {
                component.set("v.rows", undefined);
                component.set("v.error", result.responseObj);
            }       
        });

        $A.enqueueAction(getGroups);
    },

    showToastMessage : function(toastTitle, toastMsg, toastType){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
               title: toastTitle,
               message: toastMsg,
               type: toastType,
               mode: 'dismissable'
           });
        toastEvent.fire();
   }

})
