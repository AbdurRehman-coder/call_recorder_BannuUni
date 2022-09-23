//@dart=2.9
import 'package:call_log/call_log.dart';
import 'package:call_recorder/Constants/constant.dart';
import 'package:call_recorder/Screens/auth_screens/login.dart';
import 'package:call_recorder/Screens/call_recoding/call_record_view.dart';
import 'package:call_recorder/Screens/call_recoding/call_recording_screen.dart';
import 'package:call_recorder/Screens/homePage.dart';
import 'package:call_recorder/locator.dart';
import 'package:call_recorder/provider/call_record_notifier.dart';
import 'package:call_recorder/utils/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:call_recorder/Screens/mainPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'Screens/loginInPage.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  DependencyInjectionEnvironment.setup();
  await storage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  init();
  // Workmanager().registerOneOffTask(
  //   DateTime.now().millisecondsSinceEpoch.toString(),
  //   'simpleTask',
  //   existingWorkPolicy: ExistingWorkPolicy.replace,
  // );

  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CallRecordingNotifer()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'I-Droid Call Recorder',
        // home: const MainPage(),
        home: SafeArea(
          // child: LogInScreen()),
            child: CallRecorderView()),
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: FlutterEasyLoading(child: widget),
          );
        },
      ),
    );

  }

}