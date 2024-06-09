public with sharing class calloutExample {

    public static void getDummyJsonSingleUser(String userId) {

    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://dummyjson.com/users/' + userId);
    request.setMethod('GET');

    Http http = new Http();
    HttpResponse response = http.send(request);
    System.debug(response.getBody());
    System.debug(response.getStatusCode());
    System.debug(response.getStatus());
    if (response.getStatusCode() == 200) {
        //Create contact from json
        Contact cont = createContactFromJson(response.getBody());
        System.debug('New Contact::: ' + cont);
    }
    }

    private static Contact createContactFromJson(String jsonString) {
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        System.debug(jsonMap);
        System.debug(jsonMap.get('firstName'));
        System.debug(jsonMap.get('lastName'));

        Contact cont = new Contact();
        cont.FirstName = (String) jsonMap.get('firstName');
        cont.LastName = (String) jsonMap.get('lastName');

        insert cont;
        return cont;

    }

    // POST Info to dummyJson.com user endpoint
    public static void postDummyJsonSingleUser(String contactId) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:DummyJsonUser2' + '/add');
        request.setMethod('POST');
        //request.setHeader('Content-Type', 'application/json'); //set in the named credential
        request.setBody(generateDummyJsonUserPayload(contactId));
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        System.debug(response.getStatusCode());
        System.debug(response.getStatus());

        if (response.getStatusCode() >= 200 || response.getStatusCode() <= 299) {
            //create Contact from js
            System.debug('Success: contact created in other system');
            System.debug(response.getBody());
        }

    }

    private static String generateDummyJsonUserPayload(String contactId) {
        Contact cont = [SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id = :contactId];
        Map<String, Object> jsonmap = new Map<String, Object>();
        jsonmap.put('firstName', cont.FirstName);
        jsonmap.put('lastName', cont.LastName);
        jsonmap.put('email', cont.Email);
        jsonmap.put('phone', cont.Phone);
        String  jsonPayload = JSON.serialize(jsonMap);
        System.debug('Payload beign setnt to url: ' + jsonPayload);
        return jsonPayload;
    }



}