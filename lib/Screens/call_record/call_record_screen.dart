import 'package:call_log/call_log.dart';
import 'package:call_recorder/Constants/colors.dart';
import 'package:call_recorder/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:workmanager/workmanager.dart';

class CallRecordScreen extends StatefulWidget {

  const CallRecordScreen({Key? key}) : super(key: key);

  @override
  State<CallRecordScreen> createState() => _CallRecordScreenState();
}

class _CallRecordScreenState extends State<CallRecordScreen> {
  Iterable<CallLogEntry> _callLogEntries = <CallLogEntry>[];
  bool isLoading= false;

  @override
  void initState() {

    init();

    super.initState();
  }

  Future<bool> init() async {
    final Iterable<CallLogEntry> result = await CallLog.query();

    setState(() {
      _callLogEntries = result;
    });


    Workmanager().registerOneOffTask(
      DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'Call record task',
      existingWorkPolicy: ExistingWorkPolicy.replace,
      inputData: {},
    );
    return true;
   }

  @override
  Widget build(BuildContext context) {

    const TextStyle mono = TextStyle(fontFamily: 'monospace');
    final List<Widget> children = <Widget>[];
    for (CallLogEntry entry in _callLogEntries) {

      children.add(
        Column(
          children: <Widget>[
            const Divider(),
            Text('F. NUMBER  : ${entry.formattedNumber}', style: mono),
            Text('C.M. NUMBER: ${entry.cachedMatchedNumber}', style: mono),
            Text('NUMBER     : ${entry.number}', style: mono),
            Text('NAME       : ${entry.name}', style: mono),
            Text('TYPE       : ${entry.callType}', style: mono),
            Text('DATE       : ${DateTime.fromMillisecondsSinceEpoch(
                entry.timestamp!)}',
                style: mono),
            Text('DURATION   : ${entry.duration}', style: mono),
            Text('ACCOUNT ID : ${entry.phoneAccountId}', style: mono),
            Text('SIM NAME   : ${entry.simDisplayName}', style: mono),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text('Call History'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [goldenTextColor, appBarColor],
                )),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:  getLastCallRecord(children),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {  Workmanager().registerOneOffTask(
        DateTime.now().millisecondsSinceEpoch.toString(),
        'simpleTask',
        existingWorkPolicy: ExistingWorkPolicy.replace,
      ); },
        child: const Icon(Icons.add),

      ),
    );
  }

Widget getLastCallRecord(List<Widget> child){

    if(_callLogEntries.isNotEmpty){
      setState(() {
        isLoading =true;
      });
      return Column(children: child);
    }else{
      setState(() {
        isLoading =false;
      });

      return const Center(child: const CircularProgressIndicator());
    }
// }
//   void showInSnackBar(String value) {
//     Scaffold.of(context).showSnackBar(new SnackBar(
//         content: new Text(value)
//     ));
//   }
}
}

