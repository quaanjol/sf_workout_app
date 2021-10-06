({
	initFunction : function(cmp, event, helper) {
    	        
		var exerciseId = cmp.get('v.recordId');
        
        if(cmp.get('v.recordId') != null) {
			var action = cmp.get('c.getExerciseVideo');
            action.setParams({ id: exerciseId });
            
            action.setCallback(this, (res) => {
                var state = res.getState();
                if (state === 'SUCCESS') {
                    var videoUrl = res.getReturnValue();
                    cmp.set('v.videoUrl', videoUrl);
                    cmp.find('src1').getElement().src = videoUrl;
					cmp.find('src2').getElement().src = videoUrl;
					cmp.find('tutorialVideo').getElement().load()
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