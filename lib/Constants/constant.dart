import 'package:call_log/call_log.dart';
import 'package:call_recorder/model/last_record_call_model.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

//
Iterable<CallLogEntry> lastCallList = [];
//TOP-LEVEL FUNCTION PROVIDED FOR WORK MANAGER AS CALLBACK



Future<bool> init() async {
  Workmanager().registerOneOffTask(
    DateTime.now().millisecondsSinceEpoch.toString(),
    'Call record task',
    existingWorkPolicy: ExistingWorkPolicy.replace,
    inputData: {},
  );

  final Iterable<CallLogEntry> result = await CallLog.query();

  for (CallLogEntry entry in result) {
    LastCallRecordModel.lastCallRecordModel.add(LastCallRecordModel(
        name: entry.name ?? '',
        number: entry.number ?? '',
        cachedMatchedNumber: entry.cachedNumberType ?? 0,
        phoneAccountId: entry.phoneAccountId ?? '',
        callType: entry.callType ?? CallType.rejected,
        timestamp: entry.timestamp.toString(),
        simDisplayName: entry.simDisplayName ?? '',
        formateNUMBER: entry.formattedNumber ?? '',
        duration: entry.duration.toString()));
  }
  return true;
}

void callbackDispatcher() {
  Workmanager().executeTask((dynamic task, dynamic inputData) async {
    print('Background Services are Working!');

    try {
      Iterable<CallLogEntry> cLog = await CallLog.get();
      // lastCallList=cLog.toList();
      // lastCallList.length= 20;

      // for(int i=0; i<10; i++) {
      //   print(LastCallRecordModel.lastCallRecordModel[i].number);
      // }

      //

      // for(int i=0; i<20; i++){
      // //      for (CallLogEntry entry in cLog) {
      // //        LastCallRecordModel.lastCallRecordModel[i]=
      // //          lastCallList[i].number=entry.number;
      // //
      // //
      // //        print(lastCallList[i].number);
      // //
      // //
      //   LastCallRecordModel.lastCallRecordModel.map((e) =>LastCallRecordModel(number: '', cachedMatchedNumber: '', phoneAccountId: '', callType: '', timestamp: '', simDisplayName: '', formateNUMBER: '', duration: '') )
      //
      //   print(lastCallList[i].number);
      //      }

// }
      // List.generate(5, (index) {
      //  lastCallList= cLog.toList();
      //  lastCallList.length =5;
      //    print(lastCallList[index].number);
      //
      //
      // }
      //
      // );

      // lastCallList= cLog.toList();
      // lastCallList.length= 3;

      //
      // for(int i =0; i<lastCallList.length;i++ ){
      //
      //   print(lastCallList[i].number);
      // }

      // print('Queried call log entries');
      // for (CallLogEntry entry in cLog) {
      //   print('-------------------------------------');
      //   print('F. NUMBER  : ${entry.formattedNumber}');
      //   print('C.M. NUMBER: ${entry.cachedMatchedNumber}');
      //   print('NUMBER     : ${entry.number}');
      //   print('NAME       : ${entry.name}');
      //   print('TYPE       : ${entry.callType}');
      //   print('DATE       : ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)}');
      //   print('DURATION   : ${entry.duration}');
      //   print('ACCOUNT ID : ${entry.phoneAccountId}');
      //   print('ACCOUNT ID : ${entry.phoneAccountId}');
      //   print('SIM NAME   : ${entry.simDisplayName}');
      //   print('-------------------------------------');
      // }
      return true;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      return true;
    }
  });
}

Future<bool> requestPermission() async {
  var status = await Permission.phone.request();

  switch (status) {
    case PermissionStatus.denied:
    case PermissionStatus.restricted:
    case PermissionStatus.limited:
    case PermissionStatus.permanentlyDenied:
      return false;
    case PermissionStatus.granted:
      return true;
  }
}