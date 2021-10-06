public with sharing class CaresoftJWT {
        
	public static Integer leeway = 0;
    public static Time timestamp = null;
    public static Map<string, List<string>> supported_algs = new Map<string, List<string>>{
        'HS256' => new List<string>{'hash_hmac', 'HmacSHA256'},
        'HS512' => new List<string>{'hash_hmac', 'SHA512'},
        'HS384' => new List<string>{'hash_hmac', 'SHA384'},
        'RS256' => new List<string>{'openssl', 'HmacSHA256'},
        'RS384' => new List<string>{'openssl', 'SHA384'},
        'RS512' => new List<string>{'openssl', 'SHA512'}
    };
        
    @future(callout = true)
	public static void sendTokenRequest(string tk, string domain) {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        string userId = UserInfo.getUserId();
        User currentUser = [select Id, Caresoft_ipphone__c, Caresoft_expired_time__c, Old_Caresoft_expired_time__c 
                            from User where Id =: userId];
        //string csEndpoint = currentUser.Caresoft_Endpoint__c;
        //string csDomain = currentUser.Caresoft_domain__c;
        
        req.setEndpoint('https://capi.caresoft.vn/' + domain + '/thirdParty/login');
        req.setMethod('POST');
        req.setBody('token=' + tk);
        //req.setCompressed(true); // otherwise we hit a limit of 32000
        
		try {
            res = http.send(req);
            system.debug('Response is ' + res.toString());
        } catch(System.CalloutException e) {
            System.debug('Callout error: ' + e);
            System.debug(res.toString());
        }
	}
    
    @AuraEnabled
    public static string[] renderToken(string key, string domain) {
        string userId = UserInfo.getUserId();
        User currentUser = [select Id, Caresoft_ipphone__c, Caresoft_expired_time__c, Old_Caresoft_expired_time__c 
                            from User where Id =: userId];
        system.debug(currentUser);
        
    	Map<string, string> mainPayload = new Map<string, string> {
      		'ipphone' => currentUser.Caresoft_ipphone__c,
        	'expired' => string.valueOfGmt(currentUser.Caresoft_expired_time__c)
    	};
		if(currentUser.Caresoft_expired_time__c != currentUser.Old_Caresoft_expired_time__c) {
            string mainToken = encode(mainPayload, key);
            system.debug(mainToken);
            sendTokenRequest(mainToken, domain);
            
            currentUser.Old_Caresoft_expired_time__c = currentUser.Caresoft_expired_time__c;
        
            try {
                update currentUser;
                return new string[] {mainToken, domain};
            } catch(DmlException e) {
                System.debug('Callout error: ' + e);
                return null;
            }
        }
		string mainToken = encode(mainPayload, key);
        system.debug(mainToken);
        return new string[] {mainToken, domain};
    }
     
	// encode function
	@AuraEnabled
    public static string encode(Map<string, string> inputPayload, string key) {
        /*string alg = 'HS256';
        string keyId = null;
        Map<string, string> head = null;
        Map<string, string> header = new Map<string, string> {
            'typ' => 'JWT', 'alg' => alg
        };
		if(keyId != null) {
			header.put('kid', keyId);
		}
        if(head != null) {
            header.putAll(head);
        }
        List<string> segments = new List<String>();
        segments.add(urlsafeB64Encode(Blob.valueOf(jsonEncode(header))));
        segments.add(urlsafeB64Encode(Blob.valueOf(jsonEncode(payload))));
        string signInput = string.join(segments, '.');
        Blob signature = sign(signInput, key);
        segments.add(urlsafeB64Encode(signature));
		return string.join(segments, '.');*/
        
        String header = '{"typ":"JWT","alg":"HS256"}';
        String ipphone = inputPayload.get('ipphone');
        String expired = inputPayload.get('expired');
        String payload = '{"ipphone":"' + ipphone + '","expired":"' + expired + '"}';
        
        Map<string, string> mainHeader = new Map<string, string> {
                    'typ' => 'JWT', 'alg' => 'HS256'
                };
        Map<string, string> mainPayload = new Map<string, string> {
            'ipphone' => ipphone,
            'expired' => expired
        };
            
        string mainHeaderCv = string.valueOf(mainHeader).replace('+/', '-_');
        string mainPayloadCv = string.valueOf(mainPayload).replace('+/', '-_');
        
        String header64 = (EncodingUtil.base64Encode(Blob.valueOf(header)).replace('+', '-').replace('/', '_')).replace('=', '');
        
        String payload64 = (EncodingUtil.base64Encode(Blob.valueOf(payload)).replace('+', '-').replace('/', '_')).replace('=', '');
        
        
        Blob hmacData = Crypto.generateMac('hmacSHA256', Blob.valueOf(header64 + '.' + payload64), Blob.valueOf(key));
        
        String signature = (EncodingUtil.base64Encode(hmacData).replace('+', '-').replace('/', '_')).replace('=', '');
        
        String token = header64 + '.' + payload64 + '.' + signature;
        
        system.debug(token);
        
        return token;
	}
}