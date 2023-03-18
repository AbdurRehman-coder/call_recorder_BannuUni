//
// import 'dart:io';
//
// import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
// import 'package:path_provider/path_provider.dart';
//
// class CallRecordingLogic {
//   init() async {
//     try {
//       bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;
//
//       if (hasPermission) {
//         String customPath = '/flutter_audio_recorder_';
//         Directory appDocDirectory = await getApplicationDocumentsDirectory();
//
//         // io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
//         // if (Platform.isIOS) {
//         //   appDocDirectory = await getApplicationDocumentsDirectory();
//         // } else {
//         //   appDocDirectory = (await getExternalStorageDirectory())!;
//         //   // appDocDirectory = await getApplicationDocumentsDirectory();
//         // }
//
//         // can add extension like ".mp4" ".wav" ".m4a" ".aac"
//         customPath = appDocDirectory.path +
//             customPath +
//             DateTime.now().millisecondsSinceEpoch.toStringAsFixed(5);
//
//         /// .wav <---> AudioFormat.WAV
//         /// .mp4 .m4a .aac <---> AudioFormat.AAC
//         /// AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
//         _recorder =
//             FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);
//         // FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.AAC);
//
//         await _recorder.initialized;
//
//         /// after initialization
//         var current = await _recorder.current(channel: 0);
//
//         /// should be "Initialized", if all working fine
//         setState(() {
//           _current = current;
//           _currentStatus = current.status;
//           print('current status: $_currentStatus');
//         });
//       } else {
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //     const SnackBar(content: Text("You must accept permissions")));
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   _start() async {
//     try {
//       await _recorder.start();
//       var recording = await _recorder.current(channel: 0);
//       setState(() {
//         _current = recording;
//       });
//
//       const tick = Duration(milliseconds: 50);
//       Timer.periodic(tick, (Timer t) async {
//         if (_currentStatus == RecordingStatus.Stopped) {
//           t.cancel();
//         }
//
//         var current = await _recorder.current(channel: 0);
//         // print(current.status);
//         setState(() {
//           _current = current;
//           _currentStatus = _current.status;
//         });
//       });
//     } catch (e) {
//       print('call recording start exception: $e');
//     }
//   }
//
//   _resume() async {
//     await _recorder.resume();
//     setState(() {});
//   }
//
//   _pause() async {
//     await _recorder.pause();
//     setState(() {});
//   }
//
//   _stop() async {
//     print('Call stopped');
//     var result = await _recorder.stop();
//     print("Stop recording: ${result.path} ,, $result");
//     print("Stop recording: ${result.duration}");
//
//     /// TODO: Here we will implement SQLite Database
//
//     File file = widget.localFileSystem.file(result.path);
//     print("File length: ${await file.path}");
//
//     setState(() {
//       _current = result;
//       _currentStatus = _current.status;
//       musicPathList.add(_current.path);
//     });
//     setState(() {});
//
//     ///For Notifications
//     NotificationService notify= NotificationService();
//     notify.showNotifications('Saved','Call Record Saved Successfully');
//
//     getRecordedFiles();
//   }
// }