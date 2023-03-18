


import 'package:call_log/call_log.dart';

class LastCallRecordModel{
final String formateNUMBER;
final int cachedMatchedNumber;
final String name;
final String number;
final CallType callType;
final String timestamp;
final String duration;
final String phoneAccountId;
final String simDisplayName;

  LastCallRecordModel( {required this.name,required this.formateNUMBER, required this.cachedMatchedNumber, required this.number, required this.callType, required this.timestamp, required this.duration, required this.phoneAccountId, required this.simDisplayName});
   static final List<LastCallRecordModel> lastCallRecordModel =[];

}
