({
    formatTime: function(seconds) {
        seconds = parseFloat(seconds)

        var minutes, secondsLeft, hours, minutesLeft, res = '0s'

        if (seconds < 60) {

            res = seconds + 's';
        } else if (seconds >= 60 && seconds < 3600) {
            minutes = Math.floor(seconds / 60);
            secondsLeft = seconds - 60 * minutes;
            if (secondsLeft == 0) {
                res = minutes + 'm'
            }
            res = minutes + 'm ' + secondsLeft + 's';
        } else if (seconds >= 3600) {
            hours = Math.floor(seconds / 3600);
            minutesLeft = seconds - 3600 * hours;
            if (minutesLeft == 0) {
                res = hours + 'h'
            }

            if (minutesLeft >= 60) {
                minutes = Math.floor(minutesLeft / 60);
                secondsLeft = minutesLeft - 60 * minutes;
                if (secondsLeft == 0) {
                    res = minutes + 'm';
                }
            } else {
                secondsLeft = minutesLeft
            }

            res = hours + 'h ' + minutes + 'm ' + secondsLeft + 's'
        }

        return res
    },
    formatExercises: function(cmp, workout) {
        var res = []
        var totalSets = workout.Total_Set__c

        for (let i = 0; i < totalSets; i++) {
            res = res.concat(workout.Exercise_Items__r)
        }
        console.log(res)
        return res
    },
    setupCurrentExercise: function(cmp, index) {
        var thisExercise = cmp.get('v.exercises')[index]

        cmp.find('current_exercise').getElement().textContent = thisExercise.Exercise_Name__c
        cmp.find('current_exercise_time').getElement().textContent = this.formatTime(thisExercise.Time__c)
        cmp.find('current_exercise_rest').getElement().textContent = this.formatTime(thisExercise.Rest__c)
        cmp.find('videoSrc1').getElement().setAttribute('src', thisExercise.Exercise_Video__c)
        cmp.find('videoSrc2').getElement().setAttribute('src', thisExercise.Exercise_Video__c)
        cmp.find('tutorialVideo').getElement().load()

        if (index != 0) {
            cmp.find('tutorialVideo').getElement().play()
        }


        cmp.find('time_count').getElement().textContent = '\xa0' + this.formatTime(thisExercise.Time__c)
    },
    setupNextExercise: function(cmp, index) {
        let nextExercise

        if (index >= cmp.get('v.exercises').length) {
            cmp.find('next_exercise').getElement().textContent = 'No upcoming exercise'
            cmp.find('next_exercise_time').getElement().textContent = '0s'
            cmp.find('next_exercise_rest').getElement().textContent = '0s'
            cmp.find('next_exercise_img').getElement().style.display = 'none'

        } else {
            nextExercise = cmp.get('v.exercises')[index]
            cmp.find('next_exercise').getElement().textContent = nextExercise.Exercise_Name__c
            cmp.find('next_exercise_time').getElement().textContent = this.formatTime(nextExercise.Time__c)
            cmp.find('next_exercise_rest').getElement().textContent = this.formatTime(nextExercise.Rest__c)
            cmp.find('next_exercise_img').getElement().setAttribute('src', nextExercise.Exercise_Image__c)
        }
    },

    setupRest: function(cmp, index) {
        var thisExercise = cmp.get('v.exercises')[index]

        cmp.find('current_exercise').getElement().textContent = 'Resting'
        cmp.find('next_exercise_time').getElement().textContent = this.formatTime(thisExercise.Time__c)
        cmp.find('next_exercise_rest').getElement().textContent = this.formatTime(thisExercise.Rest__c)
        cmp.find('videoSrc1').getElement().setAttribute('src', cmp.get('v.restVideoUrl'))
        cmp.find('videoSrc2').getElement().setAttribute('src', cmp.get('v.restVideoUrl'))
        cmp.find('tutorialVideo').getElement().load()
        cmp.find('tutorialVideo').getElement().play()

        cmp.find('time_count').getElement().textContent = '\xa0' + this.formatTime(thisExercise.Rest__c)
    },

    startExercise: function(cmp, event, helper, currentExerciseIndex) {
        // set current exercise type as exercise
        cmp.set('v.currentExerciseType', 'exercise')

        // populate the first exercise
        this.setupCurrentExercise(cmp, currentExerciseIndex)
        this.setupNextExercise(cmp, currentExerciseIndex + 1)

        var thisExercise = cmp.get('v.exercises')[currentExerciseIndex]

        //
        var totalExerciseTimeTmp = thisExercise.Time__c
        var thisExerciseCaloBurnedPerSecond = thisExercise.Calories_burned__c / totalExerciseTimeTmp
        var totalTimeCounter = 0
        var totalCaloCounter = 0
        var currentTotalTime = cmp.get('v.totalTime')
        var currentTotalCalo = cmp.get('v.totalCalo')

        var timeCounter = setInterval(() => {
            if (totalExerciseTimeTmp >= 0) {
                cmp.set('v.timeTmp', totalExerciseTimeTmp)

                cmp.find('time_count').getElement().textContent = '\xa0' + this.formatTime(cmp.get('v.timeTmp'))

                totalExerciseTimeTmp--;
                totalTimeCounter++;
                totalCaloCounter += totalTimeCounter * thisExerciseCaloBurnedPerSecond

                cmp.set('v.totalTime', currentTotalTime + totalTimeCounter)
                cmp.set('v.totalCalo', currentTotalCalo + totalCaloCounter)
            } else {
                cmp.set('v.timeTmp', 0)
                if (currentExerciseIndex < cmp.get('v.exercises').length &&
                    currentExerciseIndex != cmp.get('v.exercises').length - 1) {
                    this.startRest(cmp, event, helper, currentExerciseIndex)
                }
                currentExerciseIndex++
                cmp.set('v.currentExerciseIndex', currentExerciseIndex)

                if (currentExerciseIndex == cmp.get('v.exercises').length) {
                    //saveWorkoutActivity
                    var action = cmp.get('c.saveWorkoutActivity');
                    action.setParams({
                        workoutId: cmp.get('v.recordId'),
                        totalCalo: parseFloat(cmp.get('v.totalCalo')),
                        totalTime: parseFloat(cmp.get('v.totalTime')),
                        totalTimeFormatted: helper.formatTime(parseFloat(cmp.get('v.totalTime'))),
                    })

                    action.setCallback(this, (res) => {
                        var state = res.getState();
                        if (state === 'SUCCESS') {
                            var msg = 'Total time: ' +
                                helper.formatTime(cmp.get('v.totalTime')) +
                                ' | ' +
                                'Total calories burned: ' +
                                parseFloat(cmp.get('v.totalCalo')).toFixed(2)

                            var finalAlert = confirm(msg)
                            if (finalAlert) {
                                var ww = window.open(window.location, '_self')
                                ww.close()
                            } else {
                                var ww = window.open(window.location, '_self')
                                ww.close()
                            }
                            return

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
                    return
                }

                clearInterval(timeCounter)
            }
        }, 1000)
    },

    startRest: function(cmp, event, helper, currentExerciseIndex) {
        // set current exercise type as rest
        cmp.set('v.currentExerciseType', 'rest')

        // set up rest view
        this.setupRest(cmp, currentExerciseIndex)

        if (currentExerciseIndex >= cmp.get('v.exercises').length) {
            return
        }

        var thisExercise = cmp.get('v.exercises')[currentExerciseIndex]

        var totalRestTimeTmp = thisExercise.Rest__c
        var totalTimeCounter = 0
        var currentTotalTime = cmp.get('v.totalTime')

        var timeCounter = setInterval(() => {
            if (totalRestTimeTmp >= 0) {
                cmp.set('v.timeTmp', totalRestTimeTmp)

                cmp.find('time_count').getElement().textContent = '\xa0' + this.formatTime(cmp.get('v.timeTmp'))

                totalRestTimeTmp--;
                totalTimeCounter++;
                cmp.set('v.totalTime', currentTotalTime + totalTimeCounter)
            } else {
                cmp.set('v.timeTmp', 0)
                currentExerciseIndex++
                cmp.set('v.currentExerciseIndex', currentExerciseIndex)
                this.startExercise(cmp, event, helper, currentExerciseIndex)
                clearInterval(timeCounter)
            }
        }, 1000)
    }
})