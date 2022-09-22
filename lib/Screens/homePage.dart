// ignore: file_names
import 'package:call_log/call_log.dart';
import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/Constants/constant.dart';
import 'package:call_recorder/Screens/call_recoding/call_record_view.dart';
import 'package:call_recorder/Screens/call_recoding/call_recording_screen.dart';
import 'package:call_recorder/Screens/call_recoding/occur_call_event.dart';

import 'package:call_recorder/Screens/call_record/call_record_screen.dart';
import 'package:call_recorder/Screens/share_history/pdf.dart';
import 'package:call_recorder/Screens/share_history/share_histroy_screen.dart';

import 'package:call_recorder/Screens/smsScreen.dart';
import 'package:call_recorder/Screens/webHistory.dart';
import 'package:call_recorder/model/last_record_call_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:workmanager/workmanager.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
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
                  )),

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
                               final  granted = await requestPermission();
                                // Navigator.push(context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>  CallEventOccur(isCallpermission: granted),),
                                // );
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
                                    "Call Recordings History",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Call recordings history screen
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


}