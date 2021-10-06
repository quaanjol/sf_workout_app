public class ABCService {
    
    @future(callout=true)
    public static void addJobApplicationFuture(string token) {
        addJobApplication(token);
    }
    
    public static void addJobApplication(string token) {        
        // Instantiate a new HTTP request
        HttpRequest req = new HttpRequest();
        
        // Set method and endpoint
        req.setEndpoint('https://capi.caresoft.vn/benhvien/thirdParty/login');
        req.setMethod('POST');
        
        // Set body
        String body = '';
        body += createJobAppJSONString(token);
        req.setBody(body);
        
        system.debug('req: ' + req);
        system.debug('req.body: ' + req.getBody());
        
        // Send HTTP request and get HTTP response
        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug('res: ' + res.getBody());
    }
    
    private static String createJobAppJSONString(string token) {
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('token', token);
        /*gen.writeStringField('firstname', 'jef');
        gen.writeStringField('lastname', 'klaas');
        gen.writeStringField('timestamp', DateTime.now().format('dd/mm/yyyy hh:mm'));
        gen.writeStringField('office_id', '2');*/
        gen.writeEndObject();
        return gen.getAsString().remove('\r').remove('\n');
    }
}