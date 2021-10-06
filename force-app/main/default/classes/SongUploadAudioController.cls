public class SongUploadAudioController {
	@AuraEnabled
    public static void updateSongAudioPath(String recId) {  
        //In lighting, the attachments are stored in content documents
        ContentDocumentLink docLink = [ SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: recId order by Id desc LIMIT 1]; 
        //ContentVersion Id uniquely identifies the attachment
        ContentVersion version = [SELECT Id FROM ContentVersion WHERE ContentDocumentId =: docLink.ContentDocumentId];
        //Update the Picture_Path field with the url of the image
        Song__c song = [SELECT Id, Audio_Url__c FROM Song__c WHERE Id =: recId];
        song.Audio_Url__c = '/sfc/servlet.shepherd/version/download/' + version.Id;
        upsert song;
    }
    
    @RemoteAction
    @AuraEnabled
    public static string getSongAudio (string id) {
        List<Song__c> songs = [select Id, Audio_Url__c
                               from Song__c 
                               where Id =: id];
        
        Song__c thisSong = null;
        if(songs.size() > 0) {
            thisSong = songs.get(0);
            return thisSong.Audio_Url__c;
        } else {
            return '';
        }
    }
}