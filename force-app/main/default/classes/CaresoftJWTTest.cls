@isTest
private class CaresoftJWTTest {
    // sendTokenRequest function
    /*@isTest static void sendTokenRequestTest1() {
        string token = 'testToken';
        string domain = 'vantai';    
        CaresoftJWT.sendTokenRequest(token, domain);
    }*/
    
    // renderToken function
    @isTest static void renderTokenTest1() {
        string token = 'testToken';
        string domain = 'vantai';
        string[] expected = new string[] {'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVkIjoiMjAyMi0wNy0zMCAwNTowMDowMCIsImlwcGhvbmUiOiIxNjUwMCJ9.XZOMc9etE1U-OJw8rYEqFTDnn7XgbqkHkFrkdWiczF4', 'vantai'};
        Test.startTest();
        string[] res = CaresoftJWT.renderToken(token, domain);
        //system.assertEquals(expected, res);
        Test.stopTest();
    }
    
    // encode function
    @isTest static void encodeTest1() {
        string expected = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHBpcmVkIjoiMjAyMC8xMi8zMSIsImlwcGhvbmUiOiIzMDAzMjIwOSJ9.ozo_rAny4WCkUiRJO5cVk7A-Sf04jydM291EgyG3D7Q';
        string mainKey = 'helloworld';
        Map<string, string> mainPayload = new Map<string, string> {
            'ipphone' => '30032209',
            'expired' => '2020/12/31'
        };
        string res = CaresoftJWT.encode(mainPayload, mainKey);
        //system.assertEquals(expected, res);
    }
}