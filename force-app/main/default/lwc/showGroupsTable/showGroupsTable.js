import { LightningElement, api, wire} from 'lwc';
import getGroups from '@salesforce/apex/showGroupsTableController.getGroups';

const columns = [
    { label: 'Group Name', fieldName: 'Name' },
    { label: 'Students Amount', fieldName: 'Students_Amount__c', type: 'number' },
    { label: 'Education Year', fieldName: 'Education_year__c', type: 'number' },
    { label: 'Education Form', fieldName: 'Education_Form__c', type: 'text' },
    { label: 'Curator', fieldName: 'Teacher_Name__c'},
];

export default class ShowGroupsTable extends LightningElement {
    @api recordId;
    columns = columns;
    rows = [];
    error;

    @wire(getGroups, {departmentId: '$recordId'})
    wiredGroups({data, error}){
        if(data){
            if(data.isSuccess){
                this.rows = data.responseObj.map(
                    record => Object.assign(
                        {"Teacher_Name__c": record?.Curator__r?.Teacher_Name__c ?? '-'}, record
                    )
                );
                this.error = undefined
            } else {
                this.rows = undefined;
                this.error = data.responseObj;
            }     
        } else if(error){
            this.error = error;
            this.rows = undefined;
        }
    }

}