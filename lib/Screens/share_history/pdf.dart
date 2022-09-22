// import 'dart:io';
//
// import 'package:call_log/call_log.dart';
// import 'package:call_recorder/Constants/constant.dart';
// import 'package:call_recorder/model/last_record_call_model.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/widgets.dart';
//
// class PdfApi {
//   static Future<File> generateCenteredText() async {
//     final record= LastCallRecordModel.lastCallRecordModel;
//     print(DateTime.fromMillisecondsSinceEpoch(int.parse(record[0].timestamp)));
//     // making a pdf document to store a text and it is provided by pdf pakage
//     final pdf = Document();
//     pdf.addPage(
//         MultiPage(
//           maxPages: 3,
//           build: (pw.Context context) => <pw.Widget>[
//             pw.Padding(
//               padding: pw.EdgeInsets.only(left: 40),
//               child: pw.Text('Last Call Record',
//                   style: pw.TextStyle(fontSize: 30)),
//             ),
//
//             pw.Wrap(
//
//               children: List<pw.Widget>.generate(20, (int index) {
//                 pw.TextStyle mono = pw.TextStyle();
//                 return pw.Container(
//                 decoration: pw.BoxDecoration(
//                   border: pw.Border.all()
//                 ),
//                   child: pw.Column(
//                     children: <pw.Widget>[
//
//                       pw.SizedBox(height: 60),
//
//                       pw.Column(children: [
//                       pw.Text('F. NUMBER  : ${record[index].formateNUMBER}',
//                       style: mono),
//                       pw.Text('C.M. NUMBER: ${record[index].cachedMatchedNumber}',
//                       style: mono),
//                       pw.Text('NUMBER     : ${record[index].number}', style: mono),
//                       pw.Text('NAME       : ${record[index].name}', style: mono),
//                       pw.Text('TYPE       : ${record[index].callType}', style: mono),
//                       pw.Text(
//                       'DATE       : ${DateTime.fromMillisecondsSinceEpoch(int.parse(record[0].timestamp))} ',
//                       style: mono),
//                       pw.Text('DURATION   : ${record[index].duration}', style: mono),
//                 pw.Text('ACCOUNT ID : ${record[index].phoneAccountId}',
//                 style: mono),
//                 pw.Text('SIM NAME   : ${record[index].simDisplayName}',
//                 style: mono),
//                 ])
//
//
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),);
//     // Text is added here in center
//
//
//     // passing the pdf and name of the docoment to make a direcotory in  the internal storage
//     return saveDocument(name: 'myContract.pdf', pdf: pdf);
//   }
//
//   // it will make a named dircotory in the internal storage and then return to its call
//   static Future<File> saveDocument({
//     required String name,
//     required Document pdf,
//   }) async {
//     // pdf save to the variable called bytes
//     final bytes = await pdf.save();
//
//     // here a beautiful pakage  path provider helps us and take dircotory and name of the file  and made a proper file in internal storage
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/$name');
//
//     await file.writeAsBytes(bytes);
//
//     // reterning the file to the top most method which is generate centered text.
//     return file;
//   }
//
// // here we use a pakage to open the existing file that we make now.
//   static Future openFile(File file) async {
//     final url = file.path;
//
//     await OpenFile.open(url);
//   }
// }