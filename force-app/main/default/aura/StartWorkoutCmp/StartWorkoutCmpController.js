({
    initFunction: function(cmp, event, helper) {

        var workoutId = cmp.get('v.recordId');

        if (workoutId != null) {
            var action = cmp.get('c.getWorkout');
            action.setParams({ id: workoutId });

            action.setCallback(this, (res) => {
                var state = res.getState();
                if (state === 'SUCCESS') {
                    var workout = res.getReturnValue();
                    console.log('workout', workout)

                    // pop up compact information
                    if (workout) {
                        cmp.set('v.workout', workout)
                        cmp.set('v.currentExerciseIndex', 0)
                        cmp.set('v.currentExerciseType', 'exercise')

                        // format exercises
                        var exercises = helper.formatExercises(cmp, workout)
                        cmp.set('v.exercises', exercises)

                        // populate the first exercise
                        helper.setupCurrentExercise(cmp, cmp.get('v.currentExerciseIndex'))
                        helper.setupNextExercise(cmp, cmp.get('v.currentExerciseIndex') + 1)

                        // populate fields
                        cmp.find('workout_name').getElement().textContent = workout.Name +
                            ' (' +
                            workout.Total_calo_burned_all_sets__c +
                            ' calories in ' +
                            helper.formatTime(workout.Total_workout_time_all_set__c) +
                            ')';

                        // set up rest video url
                        cmp.set('v.restVideoUrl', 'https://res.cloudinary.com/dmbm8j7te/video/upload/v1626238356/tt67eg4svuofsfkfxbwe.mp4')

                    } else {
                        cmp.find('workout_name').getElement().textContent = 'N/A';
                    }

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
            cmp.find('workout_name').getElement().textContent = 'N/A';
        }

    },
    startBtnClick: function(cmp, event, helper) {
        var thisConfirm = confirm("Start the workout?")

        if (thisConfirm) {
            helper.startExercise(cmp, event, helper, cmp.get('v.currentExerciseIndex'))

            cmp.find('tutorialVideo').getElement().play()
            cmp.find('startBtn').set('v.disabled', true)
            cmp.find('pauseBtn').set('v.disabled', false)
            cmp.find('skipBtn').set('v.disabled', false)
        }
    },

    pauseBtnClick: function(cmp, event, helper, currentInterval) {
        cmp.find('tutorialVideo').getElement().pause()

        var thisConfirm = confirm("Return to the workout?")

        if (thisConfirm) {
            cmp.find('tutorialVideo').getElement().play()
            return
        } else {
            var ww = window.open(window.location, '_self')
            ww.close()
            return
        }
    },

    skipBtnClick: function(cmp, event, helper) {
        cmp.find('tutorialVideo').getElement().pause()

        var thisConfirm = confirm("Skip this exercise?")
        var currentExerciseType = cmp.get('v.currentExerciseType')
        var currentExerciseIndex = cmp.get('v.currentExerciseIndex')

        if (thisConfirm) {
            if (currentExerciseIndex == (cmp.get('v.exercises').length - 1)) {

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
            }

            console.log('in skip function, current exercise type is ' + currentExerciseType)
            var interval_id = window.setInterval(() => {}, 99999);
            for (var i = 0; i < interval_id; i++) {
                window.clearInterval(i)
            }

            if (currentExerciseType.toLowerCase() == 'exercise') {
                helper.startRest(cmp, event, helper, currentExerciseIndex)
            } else if (currentExerciseType.toLowerCase() == 'rest') {
                currentExerciseIndex++
                cmp.set('v.currentExerciseIndex', currentExerciseIndex)
                helper.startExercise(cmp, event, helper, currentExerciseIndex)
            }

            console.log('in skip function, current exercise index is ' + currentExerciseIndex)
            return
        } else {
            cmp.find('tutorialVideo').getElement().play()
            return
        }
    }
})