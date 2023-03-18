import 'package:call_recorder/model/last_record_call_model.dart';
import 'package:flutter/material.dart';

class ShareHistoryScreeen extends StatefulWidget {
  const ShareHistoryScreeen({Key? key}) : super(key: key);

  @override
  State<ShareHistoryScreeen> createState() => _ShareHistoryScreeenState();
}

class _ShareHistoryScreeenState extends State<ShareHistoryScreeen> {
  @override
  Widget build(BuildContext context) {
    final record= LastCallRecordModel.lastCallRecordModel;
    return Scaffold(

      body:  ListView.builder(
          itemCount: record.length =10,
          itemBuilder: (context, int index){
        return Text(record[index].number);
      }),
    );
  }
}
