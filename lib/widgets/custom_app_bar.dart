import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  final String text;
  const CustomAppbar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:200,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.blue[800],
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(200),
          )),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row(
            //   children: [
                // TextButton.icon(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     icon: const Icon(
                //       Icons.arrow_back_sharp,
                //       color: Colors.white,
                //       size: 35,
                //     ),
                //     label: const Text(
                //       "Back",
                //       style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 25,
                //           fontFamily: "JetBrainsMono"),
                //     )),
            //   ],
            // ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 35, top: 10),
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: "JetBrainsMono"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}