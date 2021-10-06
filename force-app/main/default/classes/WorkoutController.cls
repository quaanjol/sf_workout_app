public class WorkoutController {
    @RemoteAction
    @AuraEnabled
    public static Workout__c getWorkout (string id) {
        List<Workout__c> workouts = [select Id, 
                                     Name, 
                                     Main_muscle__c, 
                                     Total_Set__c , 
                                     Total_workout_time_all_set__c, 
                                     Total_calo_burned__c, 
                                     Total_calo_burned_all_sets__c, 
                                     (select Id, Name, 
                                      Exercise__c,
                                      Exercise_Name__c, 
                                      Exercise_Image__c, 
                                      Exercise_Video__c, 
                                      Rest__c, Time__c, 
                                      Calories_burned__c 
                                      from Exercise_Items__r) 
                                    from Workout__c 
                                    where Id = :id];
        
        Workout__c thisWorkout = null;
        if(workouts.size() > 0) {
            thisWorkout = workouts.get(0);
            return thisWorkout;
        } else {
            return null;
        }
    }
    
    @RemoteAction
    @AuraEnabled
    public static Workout_Activity__c saveWorkoutActivity(Decimal totalTime, 
                                                          Decimal totalCalo, 
                                                          String totalTimeFormatted, 
                                                          string workoutId) {
                                                              
        Workout_Activity__c newWorkoutActivity = new Workout_Activity__c();
        newWorkoutActivity.Total_calo_burned__c = totalCalo;
        newWorkoutActivity.Total_time__c = totalTime;
        newWorkoutActivity.Workout__c = workoutId;
        newWorkoutActivity.Total_time_formatted__c = totalTimeFormatted;
        
        try {
            insert newWorkoutActivity;
            return newWorkoutActivity;
        } catch(DmlException e) {
            system.debug('Cannot save workout activity: ' + e.getMessage());
            return null;
        }
    }

}