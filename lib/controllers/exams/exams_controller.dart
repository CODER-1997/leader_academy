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

import '../../models/exam_model.dart';

class ExamsController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController examName = TextEditingController();
  TextEditingController examQuestionCount = TextEditingController();

  TextEditingController examEdit = TextEditingController();
  TextEditingController examQuestionCountEdit = TextEditingController();
  RxBool isCefrExam = false.obs;
  RxBool isTestTypeExam = true.obs;



  setValues(
    String name,
    String count,
  ) {
    examEdit = TextEditingController(text: name);
    examQuestionCountEdit = TextEditingController(text: count);
  }

  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('LeaderExams');
  RxInt order = 0.obs;
  GetStorage box = GetStorage();

  void addNewExam(String group) async {
    Get.back();
    isLoading.value = true;
    try {
      ExamModel newData = ExamModel(
          name: examName.text,
          questionNums: isTestTypeExam.value == false ? '100': examQuestionCount.text,
          date: DateTime.now().toString(),
          group: group, isTestType: isTestTypeExam.value, isWarned: false);
      // Create a new document with an empty list
      await _dataCollection.add({
        'items': newData.toMap(),
      });
      // Get.snackbar(
      //   "Success !",
      //   "New group added successfully !",
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
      isLoading.value = false;
      examName.clear();
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error:${e}',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoading.value = false;

// Firestore
  }

  //
  void editExam(String documentId) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderExams').doc(documentId);

      // Update the desired field
      await documentReference.update({
        'items.name': examEdit.text,
        'items.questionNums': examQuestionCountEdit.text,
      });
      Get.back();
      isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }
  void setWarningExam(String documentId) async {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
      _firestore.collection('LeaderExams').doc(documentId);

      // Update the desired field
      await documentReference.update({
        'items.isWarned': true,
         'items.warnedTime':DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())
      });
     } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }


  void addFeature(String documentId, int order) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderExams').doc(documentId);

      // Update the desired field
      await documentReference.update({
        'items.order': order,
      });
      isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void deleteExam(String documentId) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderExams').doc(documentId);

      // Update the desired field
      await documentReference.delete();
      Get.back();
      isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future<File> generatePdf(List students) async {
    final pdf = pw.Document();
    // Load the custom font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    pdf.addPage(

      pw.Page(
        build: (context) {
          return pw.Table(
            border: pw.TableBorder.all(),
            children: [
              // Table header row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Text('№', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Ismi', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Familiyasi', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Natijasi', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Foizda', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              // Table rows with conditional coloring based on grade
              ...students.map((student) {




                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: student['color']),
                  children: [
                    pw.Text(student['order'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf)),
                    pw.Text(student['name'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf)),
                    pw.Text(student['surname'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf)),
                    pw.Text(student['grade'].toString(), style: pw.TextStyle(font: ttf)),
                    pw.Text(student['percent'].toString() + "%", style: pw.TextStyle(font: ttf)),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${DateTime.now()}.pdf");
    await file.writeAsBytes(await pdf.save());
    print(file);
    return file;
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


  Future<File> generatePdfIelts(List students) async {
    final pdf = pw.Document();
    // Load the custom font
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Table(
            border: pw.TableBorder.all(),
            children: [
              // Table header row
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Text('Ismi', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Familiyasi', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Reading', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Listening', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Average Score', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Cefr Band', style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              // Table rows with conditional coloring based on grade
              ...students.map((student) {




                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: student['color']),
                  children: [
                    pw.Text(student['name'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf)),
                    pw.Text(student['surname'].toString().capitalizeFirst!, style: pw.TextStyle(font: ttf)),
                    pw.Text(student['reading'].toString(), style: pw.TextStyle(font: ttf)),
                    pw.Text(student['listening'].toString(), style: pw.TextStyle(font: ttf)),
                    pw.Text(student['overall'].toString(), style: pw.TextStyle(font: ttf)),
                    pw.Text(student['cefr_band'].toString(), style: pw.TextStyle(font: ttf)),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/${DateTime.now()}.pdf");
    await file.writeAsBytes(await pdf.save());
    print(file);
    return file;
  }

  void shareToTelegramIelts(File pdfFile,String title) async {
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


  Future<void> createPdfAndNotifyIelts(List students,String title) async {
    createPdf.value = true;
    var pdf = await generatePdfIelts(students);
    shareToTelegramIelts(pdf,title);
    createPdf.value = false;
  }



}
