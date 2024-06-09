public with sharing class contactTriggerHandler {
    public void beforeInsert(List<Contact> newContacts) {

        for (Contact c : newContacts) {
            // if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
            if (c.DummyJSON_Id__c == null) {
                Integer randomNumber = Math.round(Math.random() * 99) + 1;
                c.DummyJSON_Id__c = String.valueOf(randomNumber);
            }
            // if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
            if (Integer.valueOf(c.DummyJSON_Id__c) <= 100) {
                DummyJSONCallout.getDummyJSONUserFromId(c.DummyJSON_Id__c);
            }
        

        }
    }

    public void beforeUpdate(List<Contact> newContacts) {
        for (Contact c : newContacts) {
            if (Integer.valueOf(c.DummyJSON_Id__c) > 100) {
                DummyJSONCallout.postCreateDummyJSONUser(c.Id);
            }
        }
    }
}