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

import '../../constants/utils.dart';


class StatisticsController extends GetxController {



  static RxBool loader = false.obs;

  RxInt order = 0.obs;
  GetStorage box = GetStorage();

  List calculateUnpaidMonths(List studyDays, List payments, ) {
    var studyMonths = [];
    var paidMonths = [];
    var shouldPay = [];

    for (int i = 0; i < studyDays.length; i++) {
      if (!studyMonths.contains(
        convertDateToMonthYear(studyDays[i]['studyDay'])
            .toString()
            .removeAllWhitespace +
            "#" +
            studyDays[i]['subject'],
      )) {
        studyMonths.add(
          convertDateToMonthYear(studyDays[i]['studyDay'])
              .toString()
              .removeAllWhitespace +
              "#" +
              studyDays[i]['subject'],
        );
      }
    }

    for (int i = 0; i < payments.length; i++) {
      if (!paidMonths.contains({
        convertDateToMonthYear(payments[i]['paidDate'])
            .toString()
            .removeAllWhitespace +
            "#" +
            payments[i]['subject']
      })) {
        paidMonths.add(convertDateToMonthYear(payments[i]['paidDate'])
            .toString()
            .removeAllWhitespace +
            "#" +
            payments[i]['subject']);
      }
    }


    for (int i = 0; i < studyMonths.length; i++) {
      if (!paidMonths.contains(studyMonths[i])) {
        shouldPay.add(studyMonths[i]);
      }
    }

    return shouldPay;
  }

// Uzbek month names
  List<String> uzbekMonths = [
    "Yanvar", "Fevral", "Mart", "Aprel", "May", "Iyun", "Iyul",
    "Avgust", "Sentabr", "Oktabr", "Noyabr", "Dekabr"
  ];










  String monthPayment(List payments,String month,List studyDays,String monthInEnglish){
    loader.value  = true;
    List currentMonthPayments =[];
    List debtMonths  = calculateUnpaidMonths(studyDays, payments);
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

    if(result.isNotEmpty){
      return result;
    }
    else {
      String debtMonth = "";

      for(var item in debtMonths){
        if(item.contains(monthInEnglish)){
          debtMonth += "$item\n";
        }
      }

      if(debtMonth.isNotEmpty){
        result ="Qarz $debtMonth";
      }
      else {
        result  = "X";
      }

      loader.value = false;

      return result;



    }




  }








  Future<File> generatePdf(List students) async {
    loader.value = true;
    final pdf = pw.Document();

    // Fix sorting (surname vs. surname instead of surname vs. name)
    students.sort((a, b) => (a['surname']).compareTo(b['surname']));

    for (int i = 0; i < students.length; i++) {
      students[i]['order'] = i + 1;
    }

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    const int studentsPerPage = 10;
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
                      cell(monthPayment(student['payments'], 'Sentabr',student['studyDays'],"September"), ttf, 6),
                      cell(monthPayment(student['payments'], 'Oktabr',student['studyDays'],'October'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Noyabr',student['studyDays'],'November'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Dekabr',student['studyDays'],'December'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Yanvar',student['studyDays'],'January'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Fevral',student['studyDays'],'February'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Mart',student['studyDays'],'March'), ttf, 6),
                      cell(monthPayment(student['payments'], 'Aprel',student['studyDays'],'April'), ttf, 6),
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
    loader.value = false;

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

  Future<void> createPdfAndNotify(List students,String title, ) async {
    loader.value = true;
    createPdf.value = true;
    var pdf = await generatePdf(students);
    shareToTelegram(pdf,title);
    createPdf.value = false;
    loader.value = false;

  }





}
