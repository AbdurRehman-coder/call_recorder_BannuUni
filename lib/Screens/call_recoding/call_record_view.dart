//@dart=2.9
import 'dart:async';

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/provider/call_record_notifier.dart';
import 'package:flutter/cupertino.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// import 'package:flutter_phone_state/flutter_phone_state.dart';
// import 'package:flutter_phone_state/phone_event.dart';
import 'package:path/path.dart';

// import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';

import '../../utils/notification.dart';
import '../../widgets/custom_call_play_widget.dart';

class CallRecorderView extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  CallRecorderView({localFileSystem})
      : localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => CallRecorderViewState();
}

class CallRecorderViewState extends State<CallRecorderView>  with WidgetsBindingObserver{
  /// for playing audio recorded voices/sounds
  AudioPlayer audioPlayer = AudioPlayer();
  /// for recording the voices
  FlutterAudioRecorder2 _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  PhoneStateStatus callStatus = PhoneStateStatus.NOTHING;

  /// For AudioPlayer to play our recorded voices
  /// and watch their progress
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  List<FileSystemEntity> _files;
  // List<FileSystemEntity> _songs = [];
  List<String> _songs = [];
  List<String> generalSongsFile = [];
  Future<bool> requestPermission() async {
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

  bool callStarted = false;
  // List<RawPhoneEvent> _rawEvents;
  // List<PhoneCallEvent> _phoneEvents;

  /// The result of the user typing
  String _phoneNumber;

  // List<R> _accumulate<R>(Stream<R> input) {
  //   final items = <R>[];
  //   input.forEach((item) {
  //     if (item != null) {
  //       print('accumulate item: ${item}');
  //
  //       print('item value: ${item} ,, ${item.runtimeType} ,, ${item.toString().startsWith('statue')} ,, '
  //           '${item.toString().split('{')}');
  //       /// String Operations
  //       String splitedString = item.toString().split('{').toString();
  //       String splitValue = splitedString.replaceAll(' ', '');
  //       print('splite Value: $splitValue');
  //       String afterSplit = splitValue.substring(20, 29);
  //       print('afterSplit: ${afterSplit}');
  //       if (afterSplit == 'connected') {
  //         print('raw connected:');
  //         // RecorderExampleState().start();
  //         _start();
  //       } else if (afterSplit == 'disconnec') {
  //         print('yai tho disconnected hogay meri jan');
  //         if(callStarted == true){
  //           _stop();
  //           callStarted = false;
  //         }
  //
  //       }
  //
  //       setState(() {
  //         items.add(item);
  //       });
  //     }
  //   });
  //   return items;
  // }


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
    getRecordedFiles();

  }
  @override
  void dispose(){
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive || state == AppLifecycleState.detached){
      print('In active and detached');
      init();
      setStream();
      getRecordedFiles();
    }
    final isBackground = state == AppLifecycleState.paused;
    if(isBackground){
      print('isBackground: $isBackground');
      init();
      setStream();
    } else{
      getRecordedFiles();
      print('other isBackground: $state');
    }
  }

  /// Get recorded files path
  getRecordedFiles() async{
    print('get files called');
    String customPath = '/flutter_audio_recorder_';
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory dir = Directory(appDocDirectory.path);
    String mp3Path = dir.toString();
    print('mp3Path :: ${mp3Path}');

    _files = dir.listSync(recursive: true, followLinks: false);
    for(FileSystemEntity entity in _files) {
      String path = entity.path;
      print('All Path: $path');
      generalSongsFile.add(entity.path);
      String pathLastChar = path.substring(path.length - 5);

      if (pathLastChar == '.temp') {
        print('Yes contained with .temp');
        String removeTempString = path.replaceAll('.temp', '');
        if(removeTempString.endsWith('.wav')){
          print('remove temp String: $removeTempString');
          if(_songs.contains(removeTempString)){
            print('alread in contain');
          } else{
            print('added to the _song list');
            _songs.add(removeTempString);
          }
        }
        print('remove Temp String: ${removeTempString}');
        // path = removeTempString;
      }
        else if (path.endsWith('.wav')) {
          print('path also contained .wav');
          setState(() {
            print('entity:: ${entity}');
            if (_songs.contains(path)) {
              print('already contained');
            } else {
              _songs.add(entity.path);
            }
          });
        } else{

      }
    }

    setState(() {});

    // print('_files length: ${_files.length}');
    // print("_songs: $_songs");
    // print("songs length: ${_songs.length}");
    print("generalSongsFile : ${generalSongsFile.length}");
    for(int i = 0; i < generalSongsFile.length ; i++){
    print("generalSongsFile : ${generalSongsFile[i]}"); }


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

  var files;

  // void getFiles() async {
  //   List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
  //   // Directory directory;
  //   var root = storageInfo[0].rootDir; //storageInfo[1] for SD card, geting the root directory
  //   var fm = FileManager(root: Directory(root));
  //   files = await fm.filesTree(
  //     //set fm.dirsTree() for directory/folder tree list
  //       excludedPaths: ["/storage/emulated/0/Android"],
  //       // extensions: ["png", "pdf"] //optional, to filter files, remove to list all,
  //     //remove this if your are grabbing folder list
  //   );
  //   setState(() {}); //update the UI
  // }

  @override
  Widget build(BuildContext context) {
    getRecordedFiles();
    final callNotifier = Provider.of<CallRecordingNotifer>(context);
    /// Listen to State: Playing, Paused, Stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      if(mounted) {
        setState(() {
          // isPlaying = state == PlayerState.playing;
          callNotifier.setIsPlaying(state == PlayerState.playing);
          print('audio complete status: ${PlayerState.stopped} ,, $state');
        });
      }
    });
    /// Listen to audio Duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      if(mounted) {
        setState(() {
          // duration = newDuration;
          callNotifier.setDuration(newDuration);
        });
      }
    });
    /// Listen to audio Position
    audioPlayer.onPositionChanged.listen((newPosition) {
      if(mounted) {
        setState(() {
          // position = newPosition;
          callNotifier.setPosition(newPosition);
        });
      }
    });
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
          title: const Text('Call Record History',
            style: TextStyle(color: AppColors.buttonTextColor),),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [goldenTextColor, appBarColor],
                )),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // SizedBox(height: 16),
            // const Padding(
            //   padding: const EdgeInsets.only(top: 10, bottom: 14),
            //   child: Text('Call Record PlayList',
            //   style: TextStyle(
            //       color: AppColors.buttonTextColor, fontSize: 18, fontWeight: FontWeight.bold),),
            // ),

                _songs.isNotEmpty ?
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _songs.length,
                    itemBuilder: (context, index){
                      return
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 01, vertical: 01),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 18,
                                child: Text(index.toString(),
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14
                                  ),),
                              ),
                              title: Text(basename(_songs[index]),
                              style: const TextStyle(
                                color: AppColors.buttonTextColor, fontSize: 16, fontWeight: FontWeight.w600),),
                            // subtitle: Text(_files.toString() ?? ' '),
                              iconColor: callNotifier.isPlaying  && callNotifier.currentSongIndex == index ?
                              Colors.greenAccent : Colors.blue,
                            trailing: IconButton(
                              icon: Icon(
                                  callNotifier.isPlaying && callNotifier.currentSongIndex == index ?
                                  Icons.pause_circle : Icons.play_circle,),

                              onPressed: () async{
                                // onPlayAudio(_songs[index]);
                                callNotifier.setCurrentSongIndex(index);
                                if(callNotifier.isPlaying){
                                  await audioPlayer.pause();
                                } else{
                                  await audioPlayer.play(DeviceFileSource(_songs[index]));
                                }


                              },
                            ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(''
                                      // callNotifier.isPlaying && callNotifier.currentSongIndex == index ?
                                      // callNotifier.position.inSeconds.toString() : position.inSeconds.toString(),
                                  ),
                                  Text(callNotifier.isPlaying && callNotifier.currentSongIndex == index ?
                                      callNotifier.duration.inSeconds.toString() : duration.inSeconds.toString(),
                                  style: TextStyle(color: Colors.white70, fontSize: 14),)
                                ],
                              ),
                      ),
                          ),
                        );
                    }) :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                         SizedBox(height: 250),
                        Center(child: Text('Recorded Files will show here',
                        style: TextStyle(color: AppColors.buttonTextColor),)),
                      ],
                    )

              ],
            ),
          ),
        ),
      ),
    );
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

        await _recorder.initialized;

        /// after initialization
        var current = await _recorder.current(channel: 0);

        /// should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
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
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print('call recording start exception: $e');
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    print('Call stopped');
    var result = await _recorder.stop();
    print("Stop recording: ${result.path} ,, $result");
    print("Stop recording: ${result.duration}");

    /// TODO: Here we will implement SQLite Database

    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.path}");

    setState(() {
      _current = result;
      _currentStatus = _current.status;
      musicPathList.add(_current.path);
    });
    setState(() {});

    ///For Notifications
    NotificationService notify= NotificationService();
    notify.showNotifications('Saved','Call Record Saved Successfully');

    getRecordedFiles();
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          break;
        }
      default:
        break;
    // text = 'permission';
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  ///TODO: To be implemented for play recorded voices in Application
  void onPlayAudio(String audioPath) async {
    print('audio Path: $audioPath');
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(DeviceFileSource(audioPath));
    // await audioPlayer.play(DeviceFileSource(_current!.path!));
  }
}