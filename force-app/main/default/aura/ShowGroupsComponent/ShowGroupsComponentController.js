({
    doInit : function(component, event, helper) {

        helper.fetchGroups(component);
        helper.showToastMessage('Success!','Data fetched', 'success');
    }
})
