@isTest
public class WorkoutControllerTest {
    @isTest static void WorkoutControllerTest1() {
        Workout__c testWorkout = new Workout__c();
        testWorkout.Name = 'Test workout';
        insert testWorkout;
        
        WorkoutController.getWorkout(testWorkout.Id);
    }
    
    @isTest static void WorkoutControllerTest2() {
        String testWorkoutId = 'a052w00000COfCEAA1';
        
        WorkoutController.getWorkout(testWorkoutId);
    }
    
	@isTest static void WorkoutControllerTest3() {
        Workout__c testWorkout = new Workout__c();
        testWorkout.Name = 'Test workout';
        insert testWorkout;
        
       	Decimal totalTime = 22.09;
        Decimal totalCalo = 30.03;
        String totalTimeFormatted = '22m 9s';
        string workoutId = testWorkout.Id;
        WorkoutController.saveWorkoutActivity(totalTime, totalCalo, totalTimeFormatted, workoutId);
    }
    
    @isTest static void WorkoutControllerTest4() {  
       	Decimal totalTime = 22.09;
        Decimal totalCalo = 30.03;
        String totalTimeFormatted = '22m 9s';
        WorkoutController.saveWorkoutActivity(totalTime, totalCalo, totalTimeFormatted, null);
    }
}