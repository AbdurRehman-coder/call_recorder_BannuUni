// ignore: file_names
import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:call_log/call_log.dart';
import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/Constants/constant.dart';
import 'package:call_recorder/Screens/auth_screens/login.dart';
import 'package:call_recorder/Screens/call_recoding/call_record_view.dart';
import 'package:call_recorder/Screens/call_recoding/call_recording_screen.dart';
import 'package:call_recorder/Screens/call_recoding/occur_call_event.dart';
import 'package:file/local.dart';
import 'package:call_recorder/Screens/call_record/call_record_screen.dart';
import 'package:call_recorder/Screens/share_history/pdf.dart';
import 'package:call_recorder/Screens/share_history/share_histroy_screen.dart';

import 'package:call_recorder/Screens/smsScreen.dart';
import 'package:call_recorder/Screens/webHistory.dart';
import 'package:call_recorder/model/last_record_call_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/notification.dart';

class HomePage extends StatefulWidget {
   // HomePage({Key? key}) : super(key: key);
  final LocalFileSystem localFileSystem;
   HomePage({localFileSystem})
      : localFileSystem = localFileSystem ?? LocalFileSystem();
  // final LocalFileSystem localFileSystem;
  // HomePage({localFileSystem})
  //     : localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>with WidgetsBindingObserver {
  bool isCallRecordingSave = false;
  bool isTextMessageSave = false;
  bool isSearchingOn = false;


  /// for playing audio recorded voices/sounds
  AudioPlayer audioPlayer = AudioPlayer();
  /// for recording the voices
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  PhoneStateStatus callStatus = PhoneStateStatus.NOTHING;


  /// For AudioPlayer to play our recorded voices
  /// and watch their progress
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  List<FileSystemEntity>? _files;
  // List<FileSystemEntity> _songs = [];
  List<String> _songs = [];

  bool callStarted = false;


  /// The result of the user typing
  String? _phoneNumber;



  List<String> musicPathList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('app in resume');
    WidgetsBinding.instance.addObserver(this);
    // requestPermission();
    setStream();
    // bool granted = requestPermission();
    init();
    // getRecordedFiles();

  }
  @override
  void dispose(){
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  Future<bool> requestPermissions() async {
    var permissionStatus = await Permission.phone.request();

    switch (permissionStatus) {
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.granted:
        print('permission state: ${PermissionStatus.values}');
        return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Column(
            children: <Widget>[
              // the tab bar with two items

              AppBar(
                  elevation: 1,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [goldenTextColor, appBarColor],
                    )),
                    child: const TabBar(
                      tabs: [
                        const Tab(
                          icon: Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                        ),
                        Tab(
                          icon: const Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              actions: [
                TextButton(
                    onPressed: () async{
                      await FirebaseAuth.instance.signOut();
                      NotificationService notify= NotificationService();
                      notify.showNotifications('Logged Out','Sign in again to I-Droid App ');
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => LogInScreen()));

                    },
                    child: Text('Logout',))
              ]),

              // create widgets for each tab bar here
              Expanded(
                child: TabBarView(
                  children: [
                    // first tab bar view widget
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: ()async {
                                print('start recording');
                               final  granted = await requestPermissions();
                               if(granted){
                                 !isCallRecordingSave;
                                 init();
                                 setStream();
                               }

                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(

                                    gradient: LinearGradient(

                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  decoration :   isCallRecordingSave ? BoxDecoration(
                                     boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.4),
                                        spreadRadius: 7,
                                        blurRadius: 5,
                                        offset: const Offset(0, 1), // changes position of shadow
                                      ),
                                    ],

                                  ) :const BoxDecoration(),
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0,
                                  ),
                                  alignment: Alignment.center,

                                  child: const Text(
                                    "Start recording  ON/OFF",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () {

                                setState(() =>isTextMessageSave = !isTextMessageSave);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  decoration: isTextMessageSave ?BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.4),
                                        spreadRadius: 7,
                                        blurRadius: 5,
                                        offset: const Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ):const BoxDecoration(),
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Save Text Messages  ON/OFF",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              onPressed: () {
                                setState(() =>isSearchingOn = !isSearchingOn);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  decoration: isSearchingOn ? BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.red.withOpacity(0.4),
                                        spreadRadius: 7,
                                        blurRadius: 5,
                                        offset: const Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ):const BoxDecoration(),
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Save Search History  ON/OFF",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // second tab bar viiew widget
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Text messages history screen
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                              onPressed: () {
                                isTextMessageSave ?EasyLoading.showInfo("Please Turn On Text Message Button"): Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyInbox()),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Text Messages History",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Browser history screen
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                              //onPressed: () {},
                              onPressed: () {
                                isSearchingOn ? EasyLoading.showInfo("Please Turn On Search Button"):Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const WebHistory()));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Browser Search History",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /// Call Recording Voices
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                              onPressed: () {
                                EasyLoading.showSuccess('Please Wait... ');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CallRecorderView()));

                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Call Recording History",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ///Call recordings history screen
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                              onPressed: () {
                                // EasyLoading.showSuccess('Please Wait... ');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CallRecordScreen()));

                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Call Log History",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton(
                              onPressed: ()async {

                                // final pdfFile = await PdfApi.generateCenteredText( );
                                // PdfApi.openFile(pdfFile);

                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: const EdgeInsets.all(0.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [goldenTextColor, appBarColor],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Container(
                                  constraints: const BoxConstraints(
                                      maxWidth: 220.0, minHeight: 50.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Share History",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void setStream() {
    print('stream triggered');
    PhoneState.phoneStateStream.listen((event) {
      print('sream event: $event');
      setState(() {
        if (event != null) {
          print("stream is getting: $event");
          callStatus = event;
          print('call status: $callStatus');
          if(callStatus == PhoneStateStatus.CALL_STARTED){
            print('call Status start: $callStatus');
            _start();
          } else if(callStatus == PhoneStateStatus.CALL_ENDED){
            print('call Status stop: $callStatus');
            _stop();
            setState(() {

            });
          } else{
            print('call status: $event');
          }

        }
      });
    });
  }
  init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;

      if (hasPermission) {
        String customPath = '/flutter_audio_recorder_';
        Directory appDocDirectory = await getApplicationDocumentsDirectory();

        // io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        // if (Platform.isIOS) {
        //   appDocDirectory = await getApplicationDocumentsDirectory();
        // } else {
        //   appDocDirectory = (await getExternalStorageDirectory())!;
        //   // appDocDirectory = await getApplicationDocumentsDirectory();
        // }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toStringAsFixed(5);

        /// .wav <---> AudioFormat.WAV
        /// .mp4 .m4a .aac <---> AudioFormat.AAC
        /// AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);
        // FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.AAC);

        await _recorder?.initialized;

        /// after initialization
        var current = await _recorder?.current(channel: 0);

        /// should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print('current status: $_currentStatus');
        });
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print('call recording start exception: $e');
    }
  }

  _resume() async {
    await _recorder?.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder?.pause();
    setState(() {});
  }

  _stop() async {
    print('Call stopped');
    var result = await _recorder?.stop();
    print("Stop recording: ${result?.path} ,, $result");
    print("Stop recording: ${result?.duration}");

    /// TODO: Here we will implement SQLite Database

    File file = widget.localFileSystem.file(result?.path);
    print("File length: ${await file.path}");
    // if (file.path.endsWith('.wav')) {
    //   setState(() {
    //     if (_songs.contains(file.path)) {
    //       print('already contained');
    //     } else {
    //       _songs.add(file.path);
    //     }
    //   });
    // }
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
      musicPathList.add(_current!.path!);
    });
    setState(() {});

  }


}