import 'package:call_recorder/Constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MyInbox extends StatefulWidget {
  @override
  State createState() {
    // TODO: implement createState
    return MyInboxState();
  }
}

class MyInboxState extends State {
  Future<void> share() async {
    await FlutterShare.share(
        title: 'I-Droid Call Recorder',
        text:
            'Text messages history will appeared after approval from Developer',
        linkUrl: ' ',
        chooserTitle: 'Share to');
  }

  SmsQuery query = new SmsQuery();
  List messages = new List.empty();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          title: Text(
            'Text Messages History',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [goldenTextColor, appBarColor],
            )),
          ),
          backgroundColor: appBarColor,
          elevation: 1,
        ),
        body: Container(
          child: FutureBuilder(
            future: fetchSMS(),
            builder: (context, snapshot) {
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.markunread,
                          color: Colors.pink,
                        ),
                        title: Text(messages[index].address,
                          style: TextStyle(fontSize: 16, color: AppColors.buttonTextColor, fontWeight: FontWeight.bold),),
                        subtitle: GestureDetector(
                          onTap: share,
                          child: Text(
                            messages[index].body,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, color: AppColors.buttonTextColor,),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  Future<void> fetchSMS() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
       messages = await query.querySms(
        kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
        // address: '+254712345789',
        count: 10,
      );
      debugPrint('sms inbox messages: ${messages.length}');

      setState(() => messages = messages);
    } else {
      await Permission.sms.request();
    }

  }
}