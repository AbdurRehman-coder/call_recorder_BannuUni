import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

// import 'package:phone_state/phone_state.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/Constants/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:record/record.dart';

class CallRecordingScreen extends StatefulWidget {
  final bool isCallpermission;
  const CallRecordingScreen({Key? key, required this.isCallpermission}) : super(key: key);

  @override
  _CallRecordingScreenState createState() => _CallRecordingScreenState();
}

class _CallRecordingScreenState extends State<CallRecordingScreen> {

  bool showPlayer = false;
  String? audioPath;
  // AudioPlayer audioPlayer = AudioPlayer();
  PhoneStateStatus status = PhoneStateStatus.NOTHING;
  late bool granted ;
  bool isPlay=false;




  @override
  void initState() {
    super.initState();
    granted = widget.isCallpermission;
    granted ?  initializeCall(): getPermission();
    showPlayer = false;
    if (Platform.isIOS) setStream();
  }


  void initializeCall(){
    if (granted) {

      setStream();
      setState(() {

      });
    }
  }
  void getPermission() async{
    //TODO: To be implemented for phone permissions
    granted = await requestPermission();
  setState(() {

  });

  }

  void setStream() {
    PhoneState.phoneStateStream.listen((event) {
      setState(() {
        if (event != null) {
          status = event;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Expanded(
            child: showPlayer
                ? IconButton(
                  icon:  isPlay ? Icon(Icons.stop_circle_sharp, size: 60,): Icon(Icons.play_circle_fill, size: 60),
                  onPressed: () {


                    setState((){
                      isPlay = !isPlay;
                    });
                    if(isPlay){
                      // audioPlayer.play(UrlSource(audioPath!));
                    }else{
                      // audioPlayer.stop();
                    }

                  },
                )
                : AudioRecorder(
                    onStop: (path) {
                      if (kDebugMode) print('Recorded file path: $path');
                      setState(() {
                        audioPath = path;
                        showPlayer = true;
                      });
                    },
                  ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text(
                  "Status of call",
                  style: TextStyle(fontSize: 24),
                ),
                Icon(
                  getIcons(),
                  color: getColor(),
                  size: 80,
                ),
                const SizedBox(height: 40),
                if (Platform.isAndroid)
                  granted ? const SizedBox():Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      onPressed: !granted
                          ? () async {

                        setState(() {
                          if (granted) {
                            setStream();
                          }else{
                            EasyLoading.showError('Please Get Permission');
                          }
                        });
                      }
                          : null,
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
                          constraints:
                          const BoxConstraints(maxWidth: 220.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: const Text(
                            "Request permission of Phone",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),

              ],
            ),
          )
      ],
    ),
        ),
      // floatingActionButton: showPlayer ? FloatingActionButton(onPressed:_writeFileToStorage,child: Icon(Icons.download),):SizedBox(),
    );
  }


 void downloadFile() async {

    // setState(() {
    //   loading = true;
    //   progress = 0;
    // });
    // saveVideo will download and save file to Device and will return a boolean
    // for if the file is successfully or not
    // bool downloaded = await saveVideo(
    //    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    //     "audio${DateTime.now()}.mp4");
    // if (downloaded) {
    //   print("File Downloaded");
    // } else {
    //   print("Problem Downloading File");
    // }

    // setState(() {
    //   loading = false;
    // });
  }
  IconData getIcons() {
    switch (status) {
      case PhoneStateStatus.NOTHING:
        return Icons.clear;
      case PhoneStateStatus.CALL_INCOMING:
        return Icons.add_call;
      case PhoneStateStatus.CALL_STARTED:
        return Icons.call;
      case PhoneStateStatus.CALL_ENDED:
        return Icons.call_end;
    }
  }

  Color getColor() {
    switch (status) {
      case PhoneStateStatus.NOTHING:
      case PhoneStateStatus.CALL_ENDED:
        return Colors.red;
      case PhoneStateStatus.CALL_INCOMING:
        return Colors.green;
      case PhoneStateStatus.CALL_STARTED:
        return Colors.orange;
    }
  }

  void _createFile() async {

    File(audioPath!)
        .create(recursive: true)
        .then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      List<int> recordedData = [];
      recordedData.addAll(file.readAsBytesSync());
      await save(recordedData, 44100);
      print(file.path);
    });
  }

  void _createDirectory() async {
    String _directoryPath = '/storage/emulated/0/SoundRecorder';
    bool isDirectoryCreated = await Directory(_directoryPath).exists();
    if (!isDirectoryCreated) {
      Directory(_directoryPath).create()
      // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
  }

  void _writeFileToStorage() async {
    // _createDirectory();
    _createFile();

  }




  Future<void> save(List<int> data, int sampleRate) async {
    File recordedFile = File("/storage/emulated/0/recordedFile.wav");

    var channels = 1;

    int byteRate = ((16 * sampleRate * channels) / 8).round();

    var size = data.length;

    var fileSize = size + 36;

    Uint8List header = Uint8List.fromList([
      // "RIFF"
      82, 73, 70, 70,
      fileSize & 0xff,
      (fileSize >> 8) & 0xff,
      (fileSize >> 16) & 0xff,
      (fileSize >> 24) & 0xff,
      // WAVE
      87, 65, 86, 69,
      // fmt
      102, 109, 116, 32,
      // fmt chunk size 16
      16, 0, 0, 0,
      // Type of format
      1, 0,
      // One channel
      channels, 0,
      // Sample rate
      sampleRate & 0xff,
      (sampleRate >> 8) & 0xff,
      (sampleRate >> 16) & 0xff,
      (sampleRate >> 24) & 0xff,
      // Byte rate
      byteRate & 0xff,
      (byteRate >> 8) & 0xff,
      (byteRate >> 16) & 0xff,
      (byteRate >> 24) & 0xff,
      // Uhm
      ((16 * channels) / 8).round(), 0,
      // bitsize
      16, 0,
      // "data"
      100, 97, 116, 97,
      size & 0xff,
      (size >> 8) & 0xff,
      (size >> 16) & 0xff,
      (size >> 24) & 0xff,
      ...data
    ]);
    return recordedFile.writeAsBytesSync(header, flush: true);
  }






  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}

class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({Key? key, required this.onStop}) : super(key: key);

  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  bool _isRecording = false;
  bool _isPaused = false;
  int _recordDuration = 0;
  Timer? _timer;
  Timer? _ampTimer;
  final _audioRecorder = Record();
  Amplitude? _amplitude;



  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.wav,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();

        await _audioRecorder.start();

        bool isRecording = await _audioRecorder.isRecording();
        setState(() {
          _isRecording = isRecording;
          _recordDuration = 0;
        });

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    final path = await _audioRecorder.stop();

    widget.onStop(path!);

    setState(() => _isRecording = false);
  }

  Future<void> _pause() async {
    _timer?.cancel();
    _ampTimer?.cancel();
    await _audioRecorder.pause();

    setState(() => _isPaused = true);
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();

    setState(() => _isPaused = false);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRecordStopControl(),
                const SizedBox(width: 20),
                _buildPauseResumeControl(),
                const SizedBox(width: 20),
                _buildText(),
              ],
            ),
            if (_amplitude != null) ...[
              const SizedBox(height: 40),
              // Text('Current: ${_amplitude?.current ?? 0.0}'),
              Text('Max: ${_amplitude?.max ?? 0.0}'),
            ],
          ],
        ),
      );

  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_isRecording || _isPaused) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isRecording ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (!_isRecording && !_isPaused) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (!_isPaused) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            _isPaused ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_isRecording || _isPaused) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();
    _ampTimer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });

    _ampTimer =
        Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
      _amplitude = await _audioRecorder.getAmplitude();
      setState(() {});
    });
  }
}

// class CallRecordingScreen extends StatefulWidget {
//   const CallRecordingScreen({Key? key}) : super(key: key);
//
//   @override
//   _CallRecordingScreenState createState() => _CallRecordingScreenState();
// }
//
// class _CallRecordingScreenState extends State<CallRecordingScreen> {
//   PhoneStateStatus status = PhoneStateStatus.NOTHING;
//   bool granted = false;
//
//   Future<bool> requestPermission() async {
//     var status = await Permission.phone.request();
//
//     switch (status) {
//       case PermissionStatus.denied:
//       case PermissionStatus.restricted:
//       case PermissionStatus.limited:
//       case PermissionStatus.permanentlyDenied:
//         return false;
//       case PermissionStatus.granted:
//         return true;
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isIOS) setStream();
//   }
//
//   void setStream() {
//     PhoneState.phoneStateStream.listen((event) {
//       setState(() {
//         if (event != null) {
//           status = event;
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Phone State"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             if (Platform.isAndroid)
//               MaterialButton(
//                 child: const Text("Request permission of Phone"),
//                 onPressed: !granted
//                     ? () async {
//                   bool temp = await requestPermission();
//                   setState(() {
//                     granted = temp;
//                     if (granted) {
//                       setStream();
//                     }
//                   });
//                 }
//                     : null,
//               ),
//             const Text(
//               "Status of call",
//               style: TextStyle(fontSize: 24),
//             ),
//             Icon(
//               getIcons(),
//               color: getColor(),
//               size: 80,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   IconData getIcons() {
//     switch (status) {
//       case PhoneStateStatus.NOTHING:
//         return Icons.clear;
//       case PhoneStateStatus.CALL_INCOMING:
//         return Icons.add_call;
//       case PhoneStateStatus.CALL_STARTED:
//         return Icons.call;
//       case PhoneStateStatus.CALL_ENDED:
//         return Icons.call_end;
//     }
//   }
//
//   Color getColor() {
//     switch (status) {
//       case PhoneStateStatus.NOTHING:
//       case PhoneStateStatus.CALL_ENDED:
//         return Colors.red;
//       case PhoneStateStatus.CALL_INCOMING:
//         return Colors.green;
//       case PhoneStateStatus.CALL_STARTED:
//         return Colors.orange;
//     }
//   }
// }