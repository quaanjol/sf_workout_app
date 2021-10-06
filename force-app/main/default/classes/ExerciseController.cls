public class ExerciseController {
	@RemoteAction
    @AuraEnabled
    public static string getExerciseImg (string id) {
        List<Exercise__c> exercises = [select Id, Image__c
                               from Exercise__c 
                               where Id =: id];
        
        Exercise__c thisExercise = null;
        if(exercises.size() > 0) {
            thisExercise = exercises.get(0);
            return thisExercise.Image__c;
        } else {
            return '';
        }
    }
    
    @RemoteAction
    @AuraEnabled
    public static string getExerciseVideo (string id) {
        List<Exercise__c> exercises = [select Id, Video__c
                               from Exercise__c 
                               where Id =: id];
        
        Exercise__c thisExercise = null;
        if(exercises.size() > 0) {
            thisExercise = exercises.get(0);
            return thisExercise.Video__c;
        } else {
            return '';
        }
    }
}