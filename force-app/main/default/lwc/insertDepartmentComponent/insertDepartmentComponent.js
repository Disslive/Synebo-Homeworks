import { LightningElement, track } from 'lwc';
import insertDepartment from '@salesforce/apex/insertDepartmentController.insertDepartment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InsertDepartmentComponent extends LightningElement {
    modalOpen = false;
    department;
    error;
    disableBtn = true;
    @track depName;
    @track description;
    @track email;
    @track phone; 

    handleChange(event){
        this[event.target.name] = event.target.value;
        if(this.depName =='' || this.depName == null){
            this.disableBtn = true;
        } else{
            this.disableBtn = false;
        }
    }

    openModal(event) {
        this.modalOpen = true;
    }

    closeModal(event) {
        this.modalOpen = false;
    }

    showToast(toastVar, msg) {
        const event = new ShowToastEvent({
            title: toastVar,
            message: msg,
            variant: toastVar,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    handleSave(){
        insertDepartment({name: this.depName,  description: this.description,  email : this.email,  phone: this.phone})
            .then((result) =>{
                if(result.isSuccess){
                    this.department = result.responseObj;
                    this.error = undefined;
                    this.showToast('success', 'Department inserted with id' + this.department.Id);
                } else{
                    this.department = undefined;
                    this.error = result.responseObj;
                    this.showToast('error', this.error);
                }
            })
            .catch((error) =>{
                this.department = undefined;
                this.error = error;
                this.showToast('error', this.error);
            });
    }
}