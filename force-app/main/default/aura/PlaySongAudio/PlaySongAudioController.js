({
	initFunction : function(cmp, event, helper) {
    	
        //cmp.find("audio").getElement().load();
        
		var songId = cmp.get('v.recordId');
        
        if(cmp.get('v.recordId') == null) {
            songId = 'a032w00000JXltQAAT';
        }
        
        var action = cmp.get('c.getSongAudio');
        action.setParams({ id: songId });
        
        action.setCallback(this, (res) => {
			var state = res.getState();
            if (state === 'SUCCESS') {
            	var audioLink = res.getReturnValue();
            	cmp.set('v.audioLink', audioLink);
            	console.log('audio link is ' + audioLink);
            	cmp.find('audio-source').getElement().src = audioLink;
                cmp.find('my-audio').getElement().load();
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
	},
})