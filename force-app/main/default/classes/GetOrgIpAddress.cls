public class GetOrgIpAddress {
    public static string getIPAddress() {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.ipify.org');
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse response = http.send(request);
        String responseBody = response.getBody();
        System.debug('Your Org current IP Address: ' + responseBody);
        return responseBody;
    }
}