({
	formatTime : function(seconds) {
        seconds = parseFloat(seconds)
        
        var minutes, secondsLeft, hours, minutesLeft, res = '0s'
        
		if(seconds < 60) {
            
            res = seconds + 's';
        } else if(seconds >= 60 && seconds < 3600) {
            minutes = Math.floor(seconds / 60);
            secondsLeft = seconds - 60 * minutes;
            if(secondsLeft == 0) {
                res = minutes + 'm'
            }
            res = minutes + 'm ' + secondsLeft + 's';
        } else if(seconds >= 3600) {
            hours = Math.floor(seconds / 3600);
            minutesLeft = seconds - 3600 * hours;
            if(minutesLeft == 0) {
                res = hours + 'h'
            }

            if(minutesLeft >= 60) {
                minutes = Math.floor(minutesLeft / 60);
                secondsLeft = minutesLeft - 60 * minutes;
                if(secondsLeft == 0) {
                    res = minutes + 'm';
                }
            } else {
                secondsLeft = minutesLeft
            }

            res = hours + 'h ' + minutes + 'm ' + secondsLeft + 's'
        }
        
        return res
	},
    getOrgUrl: function() {
        var res = window.location.hostname
        return res
    },
    loadExerciseListTable: function(cmp, exerciseInfo) {
        var trList = cmp.find('exercise_list_tr').getElement()
        
        trList.innerHTML += `
        			<tr class="slds-hint-parent">
                      <th data-label="Exercise" scope="row">
                        <div class="slds-truncate">
                            <a href="../../../../${exerciseInfo.id}" target="_blank">${exerciseInfo.name}</a>
                        </div>
                      </th>
                      <td data-label="Tutorial">
                        <div class="slds-truncate">
                        	<video class="slds-border_bottom slds-border_top slds-border_left slds-border_right"
                                   aura:id="tutorialVideo" height="120" controls="true">
                                <source aura:id="src1" src="${exerciseInfo.videoUrl}" type="video/mp4"/>
                                <source aura:id="src2" src="${exerciseInfo.videoUrl}" type="video/ogg"/>
                                Your browser does not support the video tag.
                            </video>  
                        </div>
                      </td>
                      <td data-label="Time">
                        <div class="slds-truncate">
                            ${this.formatTime(exerciseInfo.time)}
                        </div>
                      </td>
                      <td data-label="Rest">
                        <div class="slds-truncate" title="Prospecting">
                            ${this.formatTime(exerciseInfo.rest)}
                        </div>
                      </td>
                    </tr>
        `;
    }
})