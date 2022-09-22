// // import 'dart:async';
// // import 'dart:io';
// //
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:phone_state/phone_state.dart';
// // import 'package:record/record.dart';
// //
// // class CallEventOccur extends StatefulWidget {
// //   // final void Function(String path) onStop;
// //
// //   const CallEventOccur({Key? key}) : super(key: key);
// //
// //   @override
// //   _CallEventOccurState createState() => _CallEventOccurState();
// // }
// //
// // class _CallEventOccurState extends State<CallEventOccur> {
// //   bool _isRecording = false;
// //   bool _isPaused = false;
// //   int _recordDuration = 0;
// //   Timer? _timer;
// //   Timer? _ampTimer;
// //   final _audioRecorder = Record();
// //   Amplitude? _amplitude;
// //   bool isRecordPermison = false;
// //
// //   PhoneStateStatus status = PhoneStateStatus.NOTHING;
// //   bool granted = false;
// //
// //   Future<bool> requestPermission() async {
// //     var status = await Permission.phone.request();
// //
// //     switch (status) {
// //       case PermissionStatus.denied:
// //       case PermissionStatus.restricted:
// //       case PermissionStatus.limited:
// //       case PermissionStatus.permanentlyDenied:
// //         return false;
// //       case PermissionStatus.granted:
// //         return true;
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     if (Platform.isIOS) setStream();
// //   }
// //
// //   void setStream() {
// //     PhoneState.phoneStateStream.listen((event) {
// //       setState(() {
// //         if (event != null) {
// //           status = event;
// //         }
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     _timer?.cancel();
// //     _ampTimer?.cancel();
// //     _audioRecorder.dispose();
// //     super.dispose();
// //   }
// //
// //   Future<void> _start() async {
// //     try {
// //       if (await _audioRecorder.hasPermission()) {
// //         // We don't do anything with this but printing
// //         final isSupported = await _audioRecorder.isEncoderSupported(
// //           AudioEncoder.aacLc,
// //         );
// //         if (kDebugMode) {
// //           print('${AudioEncoder.aacLc.name} supported: $isSupported');
// //         }
// //
// //         // final devs = await _audioRecorder.listInputDevices();
// //
// //         await _audioRecorder.start();
// //
// //         bool isRecording = await _audioRecorder.isRecording();
// //         setState(() {
// //           _isRecording = isRecording;
// //           _recordDuration = 0;
// //         });
// //
// //         _startTimer();
// //       }
// //     } catch (e) {
// //       if (kDebugMode) {
// //         print(e);
// //       }
// //     }
// //   }
// //
// //   Future<void> _stop() async {
// //     _timer?.cancel();
// //     _ampTimer?.cancel();
// //     final path = await _audioRecorder.stop();
// //
// //     // widget.onStop(path!);
// //
// //     setState(() => _isRecording = false);
// //   }
// //
// //   Future<void> _pause() async {
// //     _timer?.cancel();
// //     _ampTimer?.cancel();
// //     await _audioRecorder.pause();
// //
// //     setState(() => _isPaused = true);
// //   }
// //
// //   Future<void> _resume() async {
// //     _startTimer();
// //     await _audioRecorder.resume();
// //
// //     setState(() => _isPaused = false);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: <Widget>[
// //               _buildRecordStopControl(),
// //               const SizedBox(width: 20),
// //               _buildPauseResumeControl(),
// //               const SizedBox(width: 20),
// //               _buildText(),
// //             ],
// //           ),
// //           if (_amplitude != null) ...[
// //             const SizedBox(height: 40),
// //             Text('Current: ${_amplitude?.current ?? 0.0}'),
// //             Text('Max: ${_amplitude?.max ?? 0.0}'),
// //
// //           ],
// //
// //           if (Platform.isAndroid)
// //             MaterialButton(
// //               child: const Text("Request permission of Phone"),
// //               onPressed: !granted
// //                   ? () async {
// //                 bool temp = await requestPermission();
// //                 setState(() {
// //                   granted = temp;
// //                   if (granted) {
// //                     setStream();
// //                   }
// //                 });
// //               }
// //                   : null,
// //             ),
// //           const Text(
// //             "Status of call",
// //             style: TextStyle(fontSize: 24),
// //           ),
// //           Icon(
// //             getIcons(),
// //             color: getColor(),
// //             size: 80,
// //           )
// //
// //         ],
// //       ),
// //     );
// //   }
// //
// //   IconData getIcons() {
// //     switch (status) {
// //       case PhoneStateStatus.NOTHING:
// //         return Icons.clear;
// //       case PhoneStateStatus.CALL_INCOMING:
// //         return Icons.add_call;
// //       case PhoneStateStatus.CALL_STARTED:
// //         recordPermisson();
// //         return Icons.call;
// //       case PhoneStateStatus.CALL_ENDED:
// //         return Icons.call_end;
// //     }
// //   }
// //
// //   Color getColor() {
// //     switch (status) {
// //       case PhoneStateStatus.NOTHING:
// //       case PhoneStateStatus.CALL_ENDED:
// //         return Colors.red;
// //       case PhoneStateStatus.CALL_INCOMING:
// //         return Colors.green;
// //       case PhoneStateStatus.CALL_STARTED:
// //         return Colors.orange;
// //     }
// //   }
// //
// //   void recordPermisson() {
// //     showDialog(
// //       context: context,
// //       builder: (_) => AlertDialog(
// //         title: Text('Call Recording'),
// //         // To display the title it is optional
// //         content: Text('Would you like to record your phone call'),
// //         // Message which will be pop up on the screen
// //         // Action widget which will provide the user to acknowledge the choice
// //         actions: [
// //           TextButton(
// //             // FlatButton widget is used to make a text to work like a button
// //             onPressed: () => Navigator.pop(context),
// //             child: Text('CANCEL'),
// //             // function used to perform after pressing the button
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               isRecordPermison = true;
// //               Navigator.pop(context);
// //             },
// //             child: Text('ACCEPT'),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRecordStopControl() {
// //     late Icon icon;
// //     late Color color;
// //
// //     if (_isRecording || _isPaused) {
// //       icon = const Icon(Icons.stop, color: Colors.red, size: 30);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       final theme = Theme.of(context);
// //       icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         color: color,
// //         child: InkWell(
// //           child: SizedBox(width: 56, height: 56, child: icon),
// //           onTap: () {
// //             _isRecording ? _stop() : _start();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPauseResumeControl() {
// //     if (!_isRecording && !_isPaused) {
// //       return const SizedBox.shrink();
// //     }
// //
// //     late Icon icon;
// //     late Color color;
// //
// //     if (!_isPaused) {
// //       icon = const Icon(Icons.pause, color: Colors.red, size: 30);
// //       color = Colors.red.withOpacity(0.1);
// //     } else {
// //       final theme = Theme.of(context);
// //       icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
// //       color = theme.primaryColor.withOpacity(0.1);
// //     }
// //
// //     return ClipOval(
// //       child: Material(
// //         color: color,
// //         child: InkWell(
// //           child: SizedBox(width: 56, height: 56, child: icon),
// //           onTap: () {
// //             _isPaused ? _resume() : _pause();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildText() {
// //     if (_isRecording || _isPaused) {
// //       return _buildTimer();
// //     }
// //
// //     return const Text("Waiting to record");
// //   }
// //
// //   Widget _buildTimer() {
// //     final String minutes = _formatNumber(_recordDuration ~/ 60);
// //     final String seconds = _formatNumber(_recordDuration % 60);
// //
// //     return Text(
// //       '$minutes : $seconds',
// //       style: const TextStyle(color: Colors.red),
// //     );
// //   }
// //
// //   String _formatNumber(int number) {
// //     String numberStr = number.toString();
// //     if (number < 10) {
// //       numberStr = '0' + numberStr;
// //     }
// //
// //     return numberStr;
// //   }
// //
// //   void _startTimer() {
// //     _timer?.cancel();
// //     _ampTimer?.cancel();
// //
// //     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
// //       setState(() => _recordDuration++);
// //     });
// //
// //     _ampTimer =
// //         Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
// //       _amplitude = await _audioRecorder.getAmplitude();
// //       setState(() {});
// //     });
// //   }
// // }
//
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:call_recorder/Constants/colors.dart';
// import 'package:call_recorder/utils/notification.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:phone_state/phone_state.dart';
//
// class CallEventOccur extends StatefulWidget {
//   final bool isCallpermission;
//
//   const CallEventOccur({Key? key, required this.isCallpermission})
//       : super(key: key);
//
//   @override
//   State<CallEventOccur> createState() => _CallEventOccurState();
// }
//
// class _CallEventOccurState extends State<CallEventOccur> {
//   final recorder = FlutterSoundRecorder();
//   bool isRecordingReady = false;
//   File? audioFile;
//   String completePath = "";
//   String directoryPath = "";
//   String pa = '';
//   bool showPlayer = false;
//   AudioPlayer audioPlayer = AudioPlayer();
//   PhoneStateStatus status = PhoneStateStatus.NOTHING;
//   bool granted = false;
//   bool isPlay = false;
//
//   @override
//   void initState() {
//     super.initState();
//     showPlayer = false;
//     granted = widget.isCallpermission;
//     granted ? initializeCall() : getPermission();
//     if (Platform.isIOS) setStream();
//     init();
//   }
//
//   void initializeCall() {
//     if (granted) {
//       setStream();
//       setState(() {});
//     }
//   }
//
//   void getPermission() async {
//     granted = await requestPermission();
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     recorder.closeRecorder();
//   }
//
//   Future init() async {
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Microphone Permission not granted';
//     }
//     await recorder.openRecorder();
//     isRecordingReady = true;
//     recorder.setSubscriptionDuration(Duration(microseconds: 5000));
//   }
//
//   Future stop() async {
//     NotificationService notify= NotificationService();
//     notify.showNotifications('RECORDING','Your Recording has been Successfully Saved');
//     if (!isRecordingReady) return;
//     final path = await recorder.stopRecorder();
//     audioFile = File(path!);
//     final check = await recorder.isEncoderSupported(Codec.aacMP4);
//   }
//
//   Future record() async {
//     if (!isRecordingReady) return;
//     await recorder.startRecorder(toFile: 'audio.mp4');
//   }
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
//   void setStream() {
//     PhoneState.phoneStateStream.listen((event) {
//       setState(() {
//         if (event != null) {
//           status = event;
//           isRecording();
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           margin: EdgeInsets.only(top: 80),
//           alignment: Alignment.center,
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             StreamBuilder<RecordingDisposition>(
//                 stream: recorder.onProgress,
//                 builder: (context, snapshot) {
//                   final duration = snapshot.hasData
//                       ? snapshot.data!.duration
//                       : Duration.zero;
//                   String twoNumber(int n) => n.toString().padLeft(2, '0');
//                   final twoDigitMinute =
//                       twoNumber(duration.inMinutes.remainder(60));
//                   final twoDigitSeconds =
//                       twoNumber(duration.inSeconds.remainder(60));
//                   return Expanded(
//                       child: Text('$twoDigitMinute :$twoDigitSeconds', style: TextStyle(fontSize: 20),));
//                 }),
//             Expanded(
//               child: ElevatedButton(
//                   onPressed: () async {
//                     if (recorder.isRecording) {
//                       await stop();
//                     } else {
//                       await record();
//                     }
//                     setState(() {});
//                   },
//                   child: Icon(
//                     recorder.isRecording ? Icons.stop : Icons.mic,
//                     size: 80,
//                   )),
//             ),
//
//             SizedBox(height: 50,),
//             Expanded(
//               child: Column(
//                 children: [
//                   const Text(
//                     "Status of call",
//                     style: TextStyle(fontSize: 24),
//                   ),
//                   Icon(
//                     getIcons(),
//                     color: getColor(),
//                     size: 80,
//                   ),
//                   const SizedBox(height: 40),
//                   if (Platform.isAndroid)
//                     granted
//                         ? const SizedBox()
//                         : Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: RaisedButton(
//                               onPressed: !granted
//                                   ? () async {
//                                       bool temp = await requestPermission();
//                                       setState(() {
//                                         granted = temp;
//                                         if (granted) {
//                                           setStream();
//                                         } else {
//                                           EasyLoading.showError(
//                                               'Please Get Permission');
//                                         }
//                                       });
//                                     }
//                                   : null,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0)),
//                               padding: const EdgeInsets.all(0.0),
//                               child: Ink(
//                                 decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [goldenTextColor, appBarColor],
//                                       begin: Alignment.centerLeft,
//                                       end: Alignment.centerRight,
//                                     ),
//                                     borderRadius: BorderRadius.circular(15.0)),
//                                 child: Container(
//                                   constraints: const BoxConstraints(
//                                       maxWidth: 220.0, minHeight: 50.0),
//                                   alignment: Alignment.center,
//                                   child: const Text(
//                                     "Request permission of Phone",
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                 ],
//               ),
//             )
//           ]),
//         ),
//       ),
//       floatingActionButton: recorder.isRecording ? SizedBox() :FloatingActionButton(onPressed:()=>_onTap(context),child: isPlay
//           ? Icon(
//         Icons.stop_circle_sharp,
//         size: 60,
//       )
//           : Icon(Icons.play_circle_fill, size: 60)),
//     );
//   }
//
//   void recordingCall() async {
//     if (recorder.isRecording) {
//
//       await stop();
//     } else {
//       await record();
//     }
//     setState(() {});
//   }
//
//   Future<bool> isRecording() async {
//     switch (status) {
//       case PhoneStateStatus.NOTHING:
//         return true;
//       case PhoneStateStatus.CALL_INCOMING:
//         return true;
//       case PhoneStateStatus.CALL_STARTED:
//         recordingCall();
//         return false;
//       case PhoneStateStatus.CALL_ENDED:
//         recordingCall();
//         return true;
//     }
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
//
//   Future<String> _directoryPath() async {
//     var directory = await getApplicationDocumentsDirectory();
//     var directoryPath = directory.path;
//     return "$directoryPath/records/";
//   }
//
//   //
//   // void _createDirectory() async {
//   //   String _directoryPath = '/storage/emulated/0/SoundRecorder';
//   //   bool isDirectoryCreated = await Directory(_directoryPath).exists();
//   //   if (!isDirectoryCreated) {
//   //     Directory(_directoryPath).create()
//   //     // The created directory is returned as a Future.
//   //         .then((Directory directory) {
//   //       print(directory.path);
//   //     });
//   //   }
//   // }
//
//   // void _writeFileToStorage() async {
//   //   _createDirectory();
//   //   _createFile();
//   // }
//   // void _createFile() async {
//   //   String _directoryPath = '/storage/emulated/0/SoundRecorder';
//   //   File(_directoryPath + '/' + 'Recording_')
//   //       .create(recursive: true)
//   //       .then((File file) async {
//   //     //write to file
//   //     Uint8List bytes = await file.readAsBytes();
//   //     file.writeAsBytes(bytes);
//   //     print(file.path);
//   //   });
//   // }
//
//   Future _createFile() async {
//     File(completePath).create(recursive: true).then((File file) async {
//       //write to file
//       Uint8List bytes = await file.readAsBytes();
//       file.writeAsBytes(bytes);
//       print("FILE CREATED AT : " + file.path);
//     });
//   }
//
//   String _fileName() {
//     return "record.mp4";
//   }
//
//   Future<String> _completePath(String directory) async {
//     var fileName = _fileName();
//     return "$directory$fileName";
//   }
//
//   void _createDirectory() async {
//     bool isDirectoryCreated = await Directory(directoryPath).exists();
//     if (!isDirectoryCreated) {
//       Directory(directoryPath).create().then((Directory directory) {
//         print("DIRECTORY CREATED AT : " + directory.path);
//       });
//     }
//   }
//
//   void press() async {
//     directoryPath = await _directoryPath();
//     completePath = await _completePath(directoryPath);
//     _createDirectory();
//     _createFile();
//   }
//
//   _saveVideo() async {
//     try {
//       var appDocDir = await getTemporaryDirectory();
//       String savePath = appDocDir.path + "/audio.mp4";
//
//       // final fileName = audio.mp4; // will return you the name of your file like REC9113430186235591563.mp4
//       // final filePath = "${path.path}/$fileName";
//       //   await GallerySaver.saveVideo(filePath); //for testing
//       //   return video;
//       // }
//       // String fileUrl =
//       //     audioFile!.path;
//       // await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
//       //   print((count / total * 100).toStringAsFixed(0) + "%");
//       // });
//       final result = await ImageGallerySaver.saveFile(savePath);
//       print(result);
//     } catch (e) {
//       print(e);
//     }
//     // _toastInfo("$result");
//   }
//
//   _toastInfo(String info) {
//     // Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
//   }
//
//   Future<String> getFilePath() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//     String fileName = 'Recording.aac';
//     Directory directory;
//     try {
//       if (Platform.isAndroid) {
//         directory = (await getExternalStorageDirectory())!;
//         String newPath = "";
//         List<String> paths = directory.path.split("/");
//         for (int x = 1; x < paths.length; x++) {
//           String folder = paths[x];
//           if (folder != "Android") {
//             newPath += "/" + folder;
//           } else {
//             break;
//           }
//         }
//         newPath = newPath + "/Sounds/Recordings";
//         directory = Directory(newPath);
//       } else {
//         directory = await getTemporaryDirectory();
//       }
//       File saveFile = File(directory.path + "/$fileName");
//       if (!await directory.exists()) {
//         await directory.create(recursive: true);
//       }
//       if (await directory.exists()) {
//         return saveFile.path;
//       }
//       return '';
//     } catch (e) {
//       print(e);
//       return '';
//     }
//   }
//
//   _onTap(BuildContext context) {
//
//     setState(() {
//       isPlay = !isPlay;
//     });
//     if (isPlay) {
//       audioPlayer.play(UrlSource(audioFile!.path));
//     } else {
//       audioPlayer.stop();
//     }
//   }
// }