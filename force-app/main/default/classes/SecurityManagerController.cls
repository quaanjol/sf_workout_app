public with sharing class SecurityManagerController {

	public static final String MACENCRIPTION = 'HmacSHA256';
	public static final String MD5 = 'MD5';

	public String generateHMACKey(String messagePayload,String content_type,String requestType,String endpoint,String secretKey,String principal){
		String salt				= generateSalt();
		String timestamp		= generateTimeStamp(Datetime.now());		
		String contentMd5		= generateMD5Digest(messagePayload);
		String contentType		= content_type;	
		String signatureData	= generateSignature(requestType,contentMD5,contentType,salt,timestamp,endpoint);
		Blob data				= crypto.generateMac(MACENCRIPTION, Blob.valueOf(signatureData), Blob.valueOf(secretKey));
		String signature		= EncodingUtil.base64Encode(data);
		return principal+':'+ signature + ':' + salt + ':' + timestamp;
	}

	private String generateMD5Digest(String messagePayload){
		return EncodingUtil.convertToHex(Crypto.generateDigest(MD5, Blob.valueOf(messagePayload)));
	}

	private String generateSalt(){
		return String.valueOf(Crypto.getRandomInteger());
	}

	private String generateTimeStamp(Datetime datetimeValue){
		return string.valueof(datetimeValue.getTime() / 1000);
	}

	private String generateSignature(String requestType,String contentMD5,String contentType,String salt,String timestamp,String endpoint){
		return String.valueof(''+requestType+'\n' + contentMD5 + '\n' + contentType + '\n' + salt + '\n' + timestamp + '\n' + endpoint);
	}
}