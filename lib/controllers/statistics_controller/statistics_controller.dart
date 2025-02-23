import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StatisticsController extends GetxController {

  RxInt order = 0.obs;
  GetStorage box = GetStorage();

  String monthPayment(List payments,String month){
    List currentMonthPayments =[];
    for(var item in payments){


      if(DateFormat.MMMM('uz_UZ').format(DateFormat('dd-MM-yyyy').parse(item['paidDate'])).toLowerCase().toString()
          == month.toLowerCase().toString()){
        currentMonthPayments.add({
          'sum':item['paidSum'],
          'code':item['paymentCode'],
          'subject':item['subject'],
        });

      }
    }

    var result = "";
    for(var itm in currentMonthPayments){
        result += "${itm['sum']}-->${itm['code']} (${itm['subject']}) \n";
    }
     return result;

  }









  // Future<File> generatePdf(List students) async {
  //   final pdf = pw.Document();
  //    students.sort((a, b) => (a['surname']).compareTo(b['name']));
  //    for(int i = 0 ; i < students.length; i++){
  //      print(i);
  //      students[i]['order'] = i+1;
  //    }
  //
  //
  //   final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
  //   final ttf = pw.Font.ttf(fontData.buffer.asByteData());
  //   const int studentsPerPage = 50; // Number of students per page
  //   int totalPages = (students.length / studentsPerPage).ceil();
  //
  //   for (int i = 0; i < totalPages; i++) {
  //     final start = i * studentsPerPage;
  //     final end = (start + studentsPerPage > students.length) ? students.length : (start + studentsPerPage);
  //   pdf.addPage(
  //
  //     pw.Page(
  //       build: (context) {
  //         return pw.Table(
  //             border: pw.TableBorder.all(),
  //           children: [
  //             // Table header row
  //             pw.TableRow(
  //               decoration: pw.BoxDecoration(color: PdfColors.grey300),
  //               children: [
  //                 pw.Text(' № ', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 8,),textAlign: pw.TextAlign.center),
  //                 pw.Text(' Familiyasi ', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 8),textAlign: pw.TextAlign.center),
  //                 pw.Text(' Ismi ', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 8),textAlign: pw.TextAlign.center),
  //                 pw.Text(' Keldi ', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 8),textAlign: pw.TextAlign.center),
  //
  //                 pw.Text('Sentabr', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 pw.Text('Oktabr', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 pw.Text('Noyabr', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 pw.Text('Dekabr', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 pw.Text('Yanvar', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 pw.Text('Fevral', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 pw.Text('Mart', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 pw.Text('Aprel', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold,fontSize: 6),textAlign: pw.TextAlign.center),
  //
  //               ],
  //             ),
  //             // Table rows with conditional coloring based on grade
  //             ...students.sublist(start, end,).map((student) {
  //
  //
  //
  //
  //               return pw.TableRow(
  //                 decoration: pw.BoxDecoration(color: student['color']),
  //                 children: [
  //                   pw.Text(student['order'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text(' '+student['surname'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //
  //                   pw.Text(student['name'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text(student['startedDay'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf,fontSize: 4),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Sentabr')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Oktabr')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Noyabr')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Dekabr')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Yanvar')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Fevral')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Mart')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                   pw.Text("${monthPayment(student['payments'], 'Aprel')}", style: pw.TextStyle(font: ttf,fontSize: 6),textAlign: pw.TextAlign.center),
  //                 ],
  //               );
  //             }).toList(),
  //           ],
  //         );
  //       },
  //     ),
  //   );}
  //
  //   final output = await getTemporaryDirectory();
  //   final file = File("${output.path}/${DateTime.now()}.pdf");
  //   await file.writeAsBytes(await pdf.save());
  //   print(file);
  //   return file;
  // }
  Future<File> generatePdf(List students) async {
    final pdf = pw.Document();

    // Fix sorting (surname vs. surname instead of surname vs. name)
    students.sort((a, b) => (a['surname']).compareTo(b['surname']));

    for (int i = 0; i < students.length; i++) {
      students[i]['order'] = i + 1;
    }

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    const int studentsPerPage = 20;
    int totalPages = (students.length / studentsPerPage).ceil();

    for (int i = 0; i < totalPages; i++) {
      final start = i * studentsPerPage;
      final end = (start + studentsPerPage > students.length) ? students.length : (start + studentsPerPage);

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FixedColumnWidth(20),  // Small width for numbering
                1: pw.FlexColumnWidth(2),   // Flexible width for surname
                2: pw.FlexColumnWidth(2),   // Flexible width for name
                3: pw.FlexColumnWidth(1.5), // Flexible width for start date
                4: pw.FlexColumnWidth(1),   // Flexible width for payments
                5: pw.FlexColumnWidth(1),
                6: pw.FlexColumnWidth(1),
                7: pw.FlexColumnWidth(1),
                8: pw.FlexColumnWidth(1),
                9: pw.FlexColumnWidth(1),
                10: pw.FlexColumnWidth(1),
                11: pw.FlexColumnWidth(1),
              },
              children: [
                // Header Row
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    headerCell('№', ttf),
                    headerCell('Familiyasi', ttf),
                    headerCell('Ismi', ttf),
                    headerCell('Keldi', ttf),
                    headerCell('Sentabr', ttf, 6),
                    headerCell('Oktabr', ttf, 6),
                    headerCell('Noyabr', ttf, 6),
                    headerCell('Dekabr', ttf, 6),
                    headerCell('Yanvar', ttf, 6),
                    headerCell('Fevral', ttf, 6),
                    headerCell('Mart', ttf, 6),
                    headerCell('Aprel', ttf, 6),
                  ],
                ),
                // Student Rows
                ...students.sublist(start, end).map((student) {
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(color: student['color']),
                    children: [
                      cell(student['order'].toString(), ttf, 6),
                      cell(student['surname'].toString(), ttf, 6),
                      cell(student['name'].toString(), ttf, 6),
                      cell(student['startedDay'].toString(), ttf, 5),
                      cell(monthPayment(student['payments'], 'Sentabr'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Oktabr'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Noyabr'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Dekabr'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Yanvar'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Fevral'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Mart'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Aprel'), ttf, 6),
                    ],
                  );
                }).toList(),
              ],
            );
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${DateTime.now()}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

// Function for header styling
  pw.Widget headerCell(String text, pw.Font ttf, [double fontSize = 8]) {
    return pw.Container(
      padding: pw.EdgeInsets.all(4),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold, fontSize: fontSize),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

// Function for data cells with wrapping
  pw.Widget cell(String text, pw.Font ttf, [double fontSize = 6]) {
    return pw.Container(
      padding: pw.EdgeInsets.all(3),
      alignment: pw.Alignment.center,
      child: pw.Text(
        text,
        style: pw.TextStyle(font: ttf, fontSize: fontSize),
        textAlign: pw.TextAlign.center,
        softWrap: true, // Enables word wrapping
      ),
    );
  }

  void shareToTelegram(File pdfFile,String title) async {
    final url = pdfFile.path;
    final platform = await Platform.isAndroid;

    if (platform) {
      // Share PDF on Android
      await Share.shareXFiles([XFile(url)], text: title);
    } else {
      // Share PDF on iOS
      await Share.share(url);
    }
  }

  Rx createPdf = false.obs;

  Future<void> createPdfAndNotify(List students,String title) async {
    createPdf.value = true;
    var pdf = await generatePdf(students);
    shareToTelegram(pdf,title);
    createPdf.value = false;
  }





}
