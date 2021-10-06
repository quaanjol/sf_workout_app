var state = {
    // 'connecting' / disconnected' / 'connected' / 'registered'
    status: 'disconnected',
    session: null
};

// da cop thanh cong
//console.log('dmm');
// UA
var ua = null;

// var selfView = document.getElementById('my-video');
// var remoteView = document.getElementById('peer-video');

var selfView = null;
var remoteView = null;

var cmp = null;
var helperCmp = null;

function setComponent(component) {
  cmp = component;
  console.log('cmp now is', cmp);
}

function getComponent() {
    return cmp;
}

function setHelperComponent(helper) {
  helperCmp = helper;
  console.log('helper now is', helperCmp);
}

// HTML5 <video> elements in which local and remote video will be shown
// var selfView = document.getElementById('my-video');
// var remoteView = document.getElementById('peer-video');

function init_ua(agentId, uri, ws) {
    var socket = new JsSIP.WebSocketInterface(ws);
    var configuration = {
        sockets: [socket],
        uri: "sip:" + agentId + '@' + uri,
        password: 'sip_password',
        register_expires: 120
    };
    ua = new JsSIP.UA(configuration);
    if (selfView == null) {
        selfView = document.getElementById('my-video');
        remoteView = document.getElementById('peer-video');
    }

    // events handler
    ua.on('connected', function(e) { /* Your code here */
        state.status = 'connected';
    });

    ua.on('disconnected', function(e) { /* Your code here */
        state.status = 'disconnected';
    });

    ua.on('registered', function(e) { /* Your code here */
        state.status = 'registered';
    });

    ua.on('unregistered', function(e) { /* Your code here */
        if (ua.isConnected())
            state.status = 'unregistered';
        else
            state.status = 'disconnected';
    });

    ua.on('registrationFailed', function(e) { /* Your code here */
        if (ua.isConnected())
            state.status = 'unregistered';
        else
            state.status = 'disconnected';
    });

    ua.on('newRTCSession', function(e) { /* Your code here */
        // Avoid if busy or other incoming
        // if (state.session || state.incomingSession) {
        //     session.terminate(
        //     {
        //         status_code   : 486,
        //         reason_phrase : 'Busy Here'
        //     });
        //     return;
        // }

        var session = state.session = e.session;

        session.on('failed', function(e) {
            console.log('fail call in init file');
            state.session = null;
            csEndCall();endedCall();
            console.log('failed cmp:', getComponent());

            //save missed call
            var remote_identity = session.remote_identity;
            if(remote_identity) {
                var uri = remote_identity.uri;
                if(uri) {
                    if(cmp && cmp.type == 'c:callInitiatedPanel' && cmp.get('v.endButtonClick') == true) {
                        var user = uri.user;
                        var nownow = new Date();
                        var timeInput = [nownow.getHours(), nownow.getMinutes(), nownow.getSeconds(), nownow.getMilliseconds()];
                        var type = cmp.get('v.type');
                        var ender = 'Customer';
                        var toNumber = '';
                        var fromNumber = '';
                        var recordId = cmp.get('v.recordId');
                        var toFrom = 'to';
                        var taskId = null;
                        if(cmp.get('v.type') == 'Inbound') {
                            fromNumber = cmp.get('v.phone');
                        }
                        if(cmp.get('v.type') == 'Outbound') {
                            toNumber = cmp.get('v.phone');
                        }

                        if(type == 'Inbound') {
                            ender = 'Agent';
                            toFrom = 'from'
                        }

                        if(type == 'Outbound') {
                            var values = {
                                entityApiName : 'Task',
                                Subject: 'Missed call ' + toFrom + ' ' + cmp.get('v.phone'),
                                Priority: 'High',
                                Phone : cmp.get('v.phone'),
                                CallDurationInSeconds : 0,
                                Description : '',
                                Status: 'Not Started',
                                CallDisposition : 'Missed',
                                CallType : cmp.get('v.type'),
                            }

                            if(cmp.get('v.recordId') != '') {
                                values.WhoId = cmp.get('v.recordId');
                                values.WhatId = cmp.get('v.recordId');
                            }

                            sforce.opencti.saveLog({
                                value : values,
                                callback : function() {
                                    createCaresoftCallLog(null);
                                    console.log('save task successfully');
                                }
                            });
                        }

                        sforce.opencti.runApex({
                            apexClass : 'CaresoftController',
                            methodName : 'findMissedTask',
                            methodParams : 'phoneNumber=' + fromNumber + '&recordId=' + recordId,
                            callback : function(result) {
                                if (result.success) {
                                    //createCaresoftCallLog(result.returnValue.runApex.Id);
                                    taskId = result.returnValue.runApex.Id;
                                    console.log('result.returnValue.runApex.Id', taskId);
                                    if(taskId != null) {
                                        console.log('katarinaa');
                                        sforce.opencti.saveLog({
                                            value : {
                                                entityApiName : 'Caresoft_Call_Log__c',
                                                To_Number__c : toNumber,
                                                From_Number__c : fromNumber,
                                                Start_Time__c : new Date(),
                                                Call_Duration__c : 0,
                                                Call_note__c : '',
                                                Status__c : 'Missed',
                                                Type__c : 'Inbound',
                                                Ender__c : 'Customer',
                                                Task_ID__c : taskId
                                            },
                                            callback : function(res) {
                                                console.log('saveme', res);
                                                console.log("save call log successfully hihi!");
                                            }
                                        });
                                    }

                                    console.log('task result', result);
                                } else {
                                    console.log('task result', result);
                                    throw new Error('Unable to make a call. Contact your admin.');
                                }
                            }
                        });


                        function createCaresoftCallLog(id) {
                            console.log('katarina');
                            if(id == null) {
                                id = '';
                            }
                            sforce.opencti.saveLog({
                                value : {
                                    entityApiName : 'Caresoft_Call_Log__c',
                                    To_Number__c : toNumber,
                                    From_Number__c : fromNumber,
                                    Start_Time__c : timeInput,
                                    Call_Duration__c : 0,
                                    Call_note__c : '',
                                    Status__c : 'Missed',
                                    Type__c : 'Inbound',
                                    Ender__c : 'Customer',
                                    Task_ID__c : id
                                },
                                callback : function() {
                                    console.log("save call log successfully hihi!");
                                }
                            });
                        }

                    }
                }
            }


            if(cmp && cmp.type === 'c:callInitiatedPanel') {
                cmp.getEvent('renderPanel').setParams({
                    type : 'c:phonePanel',
                    toast : {'type': 'normal', 'message': 'Call was not picked up.'},
                    attributes : { presence : cmp.get('v.presence') }
                }).fire();

                // pop to task page
                sforce.opencti.screenPop({
                    type: sforce.opencti.SCREENPOP_TYPE.SOBJECT , //Review the arguments section.
                    params : { recordId: taskId } //Depends on the SCREENPOP_TYPE. Review the arguments section.
                });
            }
        });


        session.on('ended', function(e) {
            console.log('end call in init file');
            state.session = null;
            selfView.srcObject = null;
            remoteView.srcObject = null;
            csEndCall();
            endedCall();
            //save ended call
            var remote_identity = session.remote_identity;
            if(remote_identity) {
                var uri = remote_identity.uri;
                if(uri) {
                    if(cmp && cmp.type == 'c:connectedPanel' && cmp.get('v.endButtonClick') == true) {
                        //var nownow = new Date();
                        //var timeInput = [nownow.getFullYear(), nownow.getMonth() + 1, nownow.getDate(), nownow.getHours(), nownow.getMinutes(), nownow.getSeconds()];

                        cmp.find("ticker").getDurationInSeconds(function(duration) {
                            var callNote = document.getElementById('call-note').value;
                            console.log('duration', duration);
                            var toNumber = '';
                            var fromNumber = '';
                            var toFrom = 'to';
                            if(cmp.get('v.callType') == 'Inbound') {
                                fromNumber = cmp.get('v.phone');
                                toFrom = 'from';
                            }
                            if(cmp.get('v.callType') == 'Outbound') {
                                toNumber = cmp.get('v.phone');
                            }

                            var values = {
                                entityApiName : 'Task',
                                Subject: 'Call ' + toFrom + ' ' + cmp.get('v.phone'),
                                Priority: 'Normal',
                                Phone : cmp.get('v.phone'),
                                CallDurationInSeconds : duration,
                                Description : callNote,
                                Status: 'Completed',
                                CallDisposition : 'Successful',
                                CallType : cmp.get('v.callType'),
                            };

                            if(cmp.get('v.recordId') != '' && cmp.get('v.recordId') != 'not available') {
                                if(cmp.get('v.info')[1][1] == 'Account') {
                                    values.WhatId = cmp.get('v.recordId');
                                } else {
                                    values.WhoId = cmp.get('v.recordId');
                                }
                            }


                            sforce.opencti.saveLog({
                                value : values,
                                callback : function(response) {
                                    console.log('endcallresponsecreatetask', response);

                                    // pop to task page
                                    sforce.opencti.screenPop({
                                        type: sforce.opencti.SCREENPOP_TYPE.URL , //Review the arguments section.
                                        params : { url: '/lightning/o/Task/home' } //Depends on the SCREENPOP_TYPE. Review the arguments section.
                                    });

                                    console.log('save task successfully');
                                }
                            });

                            sforce.opencti.saveLog({
                                value : {
                                    entityApiName : 'Caresoft_Call_Log__c',
                                    To_Number__c : toNumber,
                                    From_Number__c : fromNumber,
                                    Start_Time__c : cmp.get('v.startTime'),
                                    Call_Duration__c : duration,
                                    Call_note__c : callNote,
                                    Status__c : 'Successful',
                                    Type__c : cmp.get('v.callType'),
                                    Ender__c : 'Customer',
                                    Caresoft_Call_Id__c: getCurrentCallId(),
                                },
                                callback : function() {
                                    console.log("save call log successfully!");
                                    cmp.getEvent('renderPanel').setParams({
                                        type : 'c:phonePanel',
                                        toast : {'type': 'normal', 'message': 'Call was ended by customer.'},
                                        attributes : { presence : cmp.get('v.presence') }
                                    }).fire();
                                    //cmp.set('v.status', '');
                                }
                            });
                        })

                    }

                    if(cmp && cmp.type == 'c:callInitiatedPanel') {
                        var toNumber = '';
                        var fromNumber = '';
                        if(cmp.get('v.type') == 'Inbound') {
                            fromNumber = cmp.get('v.phone');
                        }
                        if(cmp.get('v.type') == 'Outbound') {
                            toNumber = cmp.get('v.phone');
                        }

                        sforce.opencti.saveLog({
                            value : {
                                entityApiName : 'Caresoft_Call_Log__c',
                                To_Number__c : toNumber,
                                From_Number__c : fromNumber,
                                Start_Time__c : cmp.get('v.startTime'),
                                Call_Duration__c : 0,
                                Call_note__c : '',
                                Status__c : 'Successful',
                                Type__c : cmp.get('v.callType'),
                                Ender__c : 'Customer'
                            },
                            callback : function() {
                                console.log("save call log successfully!");
                                cmp.getEvent('renderPanel').setParams({
                                    type : 'c:phonePanel',
                                    toast : {'type': 'normal', 'message': 'Call was ended.'},
                                    attributes : { presence : cmp.get('v.presence') }
                                }).fire();
                                cmp.set('v.status', '');
                            }
                        });

                        // pop to task page
                        // sforce.opencti.screenPop({
                        //     type: sforce.opencti.SCREENPOP_TYPE.URL , //Review the arguments section.
                        //     params : { url: 'https://wikicanvasart-dev-ed.lightning.force.com/lightning/o/Task/home' } //Depends on the SCREENPOP_TYPE. Review the arguments section.
                        // });
                    }
                }
            }
        });

        session.on('progress', function(e) {
            console.log('progress call in init file');
            var remote_identity = session.remote_identity;
            if(remote_identity) {
                var uri = remote_identity.uri;
                if(uri) {
                    var user = uri.user;
                    console.log('uri is', uri);
                    console.log('progress cmp:', getComponent());
                    var contact = null;

                    if(cmp && cmp.get('v.state') != 'Dialing' && cmp.type === 'c:phonePanel') {
                        sforce.opencti.setSoftphonePanelVisibility({
                            visible: true,
                            callback: function() {
                                console.log('it is me that make the softphone visible.');
                            }
                        });

                        var callback = function(response) {
                            if (response.success) {
                                console.log('API method call executed successfully! returnValue:', response.returnValue);
                                var firstKey = Object.keys(response.returnValue)[0];
                                var res = response.returnValue[firstKey];
                                console.log('first key is', firstKey);
                                console.log('response when there is an incoming call  is', res);
                                var attributes = {
                                    'state' : 'Incoming call',
                                    'recordName' : 'Anonymous',
                                    'phone' : user,
                                    'title' : 'Unknown',
                                    'recordId' : 'not available',
                                    'type': 'Inbound',
                                    'info': [['Name', 'Unknown']],
                                    'account': { 'Name': 'Unknown', 'Id': '' }
                                };

                                if(res) {
                                  var result = Object.keys(res).map((key) => [key, res[key]]);
                                  if(res.RecordType == 'Contact') {
                                    attributes = {
                                        'state' : 'Incoming call',
                                        'recordName' : res.Name,
                                        'phone' : user,
                                        'title' : '',
                                        'recordId' : res.Id,
                                        'type': 'Inbound',
                                        'info': result,
                                        'account': { 'Name': '', 'Id': ''}
                                    };
                                  } else if(res.RecordType == 'Account') {
                                    attributes = {
                                        'state' : 'Incoming call',
                                        'recordName' : res.Name,
                                        'phone' : user,
                                        'title' : '',
                                        'recordId' : res.Id,
                                        'type': 'Inbound',
                                        'info': result,
                                        'account': { 'Name': res.Name, 'Id': res.Id}
                                    };
                                  }
                                  console.log('array result is', result);
                                  helperCmp.initiateCallPanel(cmp, attributes);
                                  console.log('got into the wanted if block. yay');
                                }
                                console.log('helperCmpp', helperCmp);
                                helperCmp.initiateCallPanel(cmp, attributes);
                                console.log('got into the wanted if block. yay');
                            } else {
                                console.error('Something went wrong! Errors:', response.errors);
                            }
                        };

                        function searchAndScreenPop() {
                            //Invokes API method
                            sforce.opencti.searchAndScreenPop({
                                searchParams : user,
                                queryParams : '',
                                callType : 'inbound',
                                deferred: false,
                                callback : callback
                            });
                        }
                        searchAndScreenPop();
                    }
                    csCallRinging(user);
                    hasCallRinging(user);
                }
            }
        });

        session.on('accepted', function(e) {
            state.session = session;
            var peerconnection = session.connection;
            var localStream = peerconnection.getLocalStreams()[0];
            var remoteStream = peerconnection.getRemoteStreams()[0];
            selfView.srcObject = localStream;
            remoteView.srcObject = remoteStream;
            console.log("maybe this is why");
            csAcceptCall();
            acceptedCall();
        });

    });

    ua.start();
};

function register() {
    if (!ua || !ua.isRegistered()) {
        init_ua();
    }
}

function unregister() {
    if (ua && ua.isRegistered()) {
        ua.unregister();
    }
    if (ua && typeof ua.stop == 'function') {
        ua.stop();
    }
}

function dial_call(uri) {

    if (!ua || !ua.isConnected) return;

    // Register callbacks to desired call events
    var eventHandlers = {
        'progress': function(data) { /* Your code here */ },
        'failed': function(data) { /* Your code here */ },
        'confirmed': function(data) { /* Your code here */ },
        'ended': function(data) { /* Your code here */ }
    };

    var options = {
        'eventHandlers': eventHandlers,
        // 'extraHeaders': [ 'X-Foo: foo', 'X-Bar: bar' ],
        'mediaConstraints': { 'audio': true, 'video': false },
        'sessionTimersExpires': 1800,
        'pcConfig': {
            rtcpMuxPolicy: "require",
            'iceServers': [
                { 'url': 'stun:stun.l.google.com:19302' },
                // { 'urls': 'turn:s2.caresoft.vn', 'username': 'foo', 'credential': ' 1234'}
            ]
        },
        rtcOfferConstraints: {
            offerToReceiveAudio: 1,
            offerToReceiveVideo: 0
        }
    };

    ua.call(uri, options);
};

function answer_call() {
    console.log('Tryit: answer_call');
    var session = state.session;
    if (session) {

        session.answer({
            // pcConfig: peerconnection_config,
            // TMP:
            sessionTimersExpires: 1800,
            mediaConstraints: { audio: true, video: false },
            // extraHeaders: [
            //   'X-Can-Renegotiate: ' + String(localCanRenegotiateRTC())
            // ],
            pcConfig: {
                rtcpMuxPolicy: "require",
                'iceServers': [
                    { 'url': 'stun:stun.l.google.com:19302' },
                    // { 'urls': 'turn:example.com', 'username': 'foo', 'credential': ' 1234'}
                ]
            },
            rtcOfferConstraints: {
                offerToReceiveAudio: 1,
                offerToReceiveVideo: 0
            }
        });
    }
};

function terminate_call() {
    var session = state.session;
    if (session) {
        session.terminate();
    }
};

function sendDTMF(digit) {
    var session = state.session;
    if (session) {
        session.sendDTMF(digit);
    }
}
