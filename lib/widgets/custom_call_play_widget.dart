
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CourseLessonsWidget extends StatelessWidget {
  CourseLessonsWidget({Key? key,
    this.title, this.lectureNo, this.duration, this.courseIcon, this.iconColor,
    this.playTap,
  }) : super(key: key);

  String? title;
  int? lectureNo;
  int? duration;
  IconData? courseIcon;
  Color? iconColor;
  VoidCallback? playTap;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 08),
        child: Row(
          children: [
            /// Lecture Number
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.3),
              radius: 18,
              child: Text('0$lectureNo',
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14
                ),),
            ),
            const SizedBox(width: 12,),
            /// Lecture Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  ),),
                Text('${duration} mins',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white60,
                    fontSize: 12,
                  ),),

              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: playTap,
                child: Icon(courseIcon, color: iconColor,))
          ],
        ),
      ),
    );
  }
}