import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:path/path.dart';

// import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:phone_state/phone_state.dart';

import '../../widgets/custom_call_play_widget.dart';

class CallRecorderView extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  CallRecorderView({localFileSystem})
      : localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<StatefulWidget> createState() => CallRecorderViewState();
}

class CallRecorderViewState extends State<CallRecorderView> {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  PhoneStateStatus callStatus = PhoneStateStatus.NOTHING;

  List<FileSystemEntity>? _files;
  // List<FileSystemEntity> _songs = [];
  List<String> _songs = [];
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

  List<String> musicPathList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    setStream();
    // bool granted = requestPermission();
    _init();
    // if (Platform.isIOS) setStream();
    // getFiles();

  }

  /// Get recorded files path
  getRecordedFiles() async{
    String customPath = '/flutter_audio_recorder_';
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory dir = Directory(appDocDirectory.path);
    String mp3Path = dir.toString();
    print('mp3Path :: ${mp3Path}');

    _files = dir.listSync(recursive: true, followLinks: false);
    for(FileSystemEntity entity in _files!) {
      String path = entity.path;
      if(path.endsWith('.wav')) {
        setState(() {
          print('entity:: ${entity}');
          if(_songs.contains(entity.path)) {
            print('already contained');

          } else{
            _songs.add(entity.path);
          }
        });
      }

    }
    print('_files length: ${_files!.length}');
    print("_songs: $_songs");
    print("songs length: ${_songs.length}");

    // io.Directory dir = io.Directory('');
    // // io.Directory? extDir = await getExternalStorageDirectory();
    // // String pdfPath = extDir! + "/pdf/";
    // List<FileSystemEntity>? _filesystem;
    // _filesystem = dir.listSync(recursive: true, followLinks: false).cast<FileSystemEntity>();
    // print('file system length: ${_filesystem}');
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
    // print('current path data type: ${_current!.path.runtimeType} ,, ${_current!.path!}, ${musicPathList.length}');
    /// Call to get the Recorded files from the storage
    getRecordedFiles();
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(height: 16),
          Text('Call Record PlayList',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

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
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14
                                ),),
                            ),
                            title: Text(basename(_songs[index])),
                          // subtitle: Text(_files.toString() ?? ' '),
                          trailing: IconButton(
                            icon: Icon(Icons.play_circle),
                            onPressed: (){
                              // onPlayAudio(musicPathList[index].toString());
                              onPlayAudio(_songs[index]);

                            },
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
                      Center(child: Text('First Make a Call to Record...')),
                    ],
                  )

            ],
          ),
        ),
      ),
    );
  }

  _init() async {
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

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;

        /// after initialization
        var current = await _recorder!.current(channel: 0);

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
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder!.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder!.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder!.stop();
    print("Stop recording: ${result!.path} ,, $result");
    print("Stop recording: ${result.duration}");

    /// TODO: Here we will implement SQLite Database

    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
      musicPathList.add(_current!.path!);
    });
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

  void onPlayAudio(String audioPath) async {
    print('audio Path: $audioPath');
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(DeviceFileSource(audioPath));
    // await audioPlayer.play(DeviceFileSource(_current!.path!));
  }
}