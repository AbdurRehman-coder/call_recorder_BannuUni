import 'package:call_recorder/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:call_recorder/Screens/recentwebpages.dart';
import 'package:url_launcher/url_launcher.dart';

class WebHistory extends StatefulWidget {
  const WebHistory({Key? key}) : super(key: key);

  @override
  State<WebHistory> createState() => _WebHistoryState();
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _WebHistoryState extends State<WebHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Recent Web Pages',
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              //1st Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Google"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://google.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "google.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //2nd Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Facebook"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://facebook.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "facebook.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //3rd Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Youtube"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://youtube.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "youtube.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //4th Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Yahoo"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://yahoo.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "yahoo.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //5th Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Upwork"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://upwork.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "upwork.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //6th Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Fiverr"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://fiverr.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "fiverr.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //7th Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Whatsapp"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://web.whatsapp.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "whatsapp.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //8th Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Github"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http:/github.com/';
                        launchURL(url);
                      },
                      child: Text(
                        "github.com",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //9th Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Flutter"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://flutter.dev/';
                        launchURL(url);
                      },
                      child: Text(
                        "flutter.dev",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
              //10th Site
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text("Dart & Flutter Packages"),
                    subtitle: GestureDetector(
                      onTap: () {
                        const url = 'http://pub.dev/';
                        launchURL(url);
                      },
                      child: Text(
                        "pub.dev",
                        maxLines: 2,
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                color: blackTextColor,
                height: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
