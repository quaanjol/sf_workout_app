({
	initFunction : function(cmp, event, helper) {
    	        
		var workoutId = cmp.get('v.recordId');
        
        if(workoutId != null) {
			var action = cmp.get('c.getWorkout');
            action.setParams({ id: workoutId });
            
            action.setCallback(this, (res) => {
                var state = res.getState();
                if (state === 'SUCCESS') {
                    var workout = res.getReturnValue();
                	console.log(workout)
                
                	// pop up compact information
                    if(workout) {
                        cmp.find('total_sets').getElement().textContent = workout.Total_Set__c;
                        cmp.find('total_calories').getElement().textContent = workout.Total_calo_burned_all_sets__c;
                
                        var totalTime = parseFloat(workout.Total_workout_time_all_set__c)
                        cmp.find('total_time').getElement().textContent = helper.formatTime(totalTime)

                    } else {
                        cmp.find('total_sets').getElement().textContent = 'N/A';
                        cmp.find('total_time').getElement().textContent = 'N/A';
                        cmp.find('total_calories').getElement().textContent = 'N/A';
					}
        
        			// load table view
                    workout.Exercise_Items__r.forEach(item => {
                        var exerciseInfo = {
	                        id: item.Exercise__c,
                            name: item. Exercise_Name__c,
	                        videoUrl: item.Exercise_Video__c, 
	                        time: item.Time__c, 
	                        rest: item.Rest__c
                        }
                        helper.loadExerciseListTable(cmp, exerciseInfo)
                    })
	                
                    
                } else if (state === 'INCOMPLETE') {
                    console.log('state is incomplete');
                } else if (state === 'ERROR') {
                    var errors = res.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                } else {
                    console.log('Unknown errors');
                }
            });
        
            $A.enqueueAction(action);
        } else {
    		return
		}
        
	},
})