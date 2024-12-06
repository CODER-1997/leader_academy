import 'dart:io';

import 'package:leader/screens/students_by_group/simple_exam_as_img.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
 import 'package:pdf/pdf.dart';
import 'package:screenshot/screenshot.dart';
 import '../../constants/custom_widgets/gradient_button.dart';
import '../../constants/form_field.dart';

import '../../controllers/exams/exams_controller.dart';
import '../../controllers/students/student_controller.dart';

class ExamResults extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String examTitle;
  final String examCount;
  final String examDate;

  ExamResults({
    required this.groupId,
    required this.groupName,
    required this.examTitle,
    required this.examCount,
    required this.examDate,
  });

  @override
  State<ExamResults> createState() => _ExamResultsState();
}

class _ExamResultsState extends State<ExamResults> {
  StudentController studentController = Get.put(StudentController());

  GetStorage box = GetStorage();

  RxList students = [].obs;
  RxBool messageLoader = false.obs;
  RxBool examProcess = false.obs;

  RxList studentExams = [].obs;

  bool isAlreadyTakenExam(List list) {
    bool hasTaken = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['examDate'] == widget.examDate) {
        hasTaken = true;
        break;
      }
    }
    return hasTaken;
  }

  PdfColor getColor(double num) {
    if (num > 85) {
      return PdfColors.green;
    } else if (num >= 71 && num <= 85) {
      return PdfColors.yellow;
    } else if (num >= 56 && num <= 70) {
      return PdfColors.pinkAccent;
    } else {
      return PdfColors.red;
    }
  }

  String examId(List list) {
    String examId = '';
    for (int i = 0; i < list.length; i++) {
      if (list[i]['examDate'] == widget.examDate) {
        examId = list[i]['id'];
        break;
      }
    }
    return examId;
  }

  String examCount(List list) {
    String hasTaken = '';
    for (int i = 0; i < list.length; i++) {
      if (list[i]['examDate'] == widget.examDate) {
        hasTaken = "${list[i]['howMany']}/${list[i]['from']}";
        break;
      }
    }
    return hasTaken;
  }

  RxBool isEdit = false.obs;

  ExamsController examsController = Get.put(ExamsController());
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        title: Text(widget.examTitle),
        actions: [
          IconButton(
              onPressed: () {
                isEdit.value = !isEdit.value;
              },
              icon: Icon(Icons.edit)),
          SizedBox(
            width: 32,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('LeaderStudents')
                    .where('items.isDeleted', isEqualTo: false)
                    .where('items.groupId', isEqualTo: widget.groupId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Xatolik: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    var list = snapshot.data!.docs;

                    students.clear();
                    for (int i = 0; i < list.length; i++) {
                      students.add({
                        'name': list[i]['items']['name'],
                        'exams': list[i]['items']['exams'],
                        'id': list[i].id,
                        'surname': list[i]['items']['surname'],
                        'uniqueId': list[i]['items']['uniqueId'],
                      });
                    }

                    return students.length != 0
                        ? Obx(() => Column(
                      children: [
                        for (int i = 0; i < students.length; i++)
                          Obx(() => Container(
                            margin: EdgeInsets.symmetric(
                                vertical: .5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      "${i + 1}",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                        BorderRadius.circular(
                                            112)),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(4),
                                    width: 28,
                                    height: 28,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                      '${students[i]['name'].toString().capitalizeFirst} ${students[i]['surname'].toString().capitalizeFirst}')
                                ],
                              ),
                              trailing: isAlreadyTakenExam(
                                  students[i]
                                  ['exams']) ==
                                  false ||
                                  isEdit == true
                                  ? SizedBox(
                                width: Get.width / 10,
                                child: TextFormField(
                                  buildCounter: (context,
                                      {required int
                                      currentLength,
                                        required bool
                                        isFocused,
                                        required int?
                                        maxLength}) {
                                    return null; // Hides the counter
                                  },
                                  decoration:
                                  InputDecoration(
                                    hintText: '',
                                  ),
                                  minLines: 1,
                                  maxLength: 3,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly,
                                    // Allow only numbers
                                    MaxValueInputFormatter(
                                        int.parse(widget
                                            .examCount)),
                                    // Custom formatter for max value
                                  ],
                                  keyboardType:
                                  TextInputType.number,
                                  onChanged: (value) {
                                    var id =
                                    students[i]['id'];
                                    var uniqueId =
                                    students[i]
                                    ['uniqueId'];
                                    var exams = students[i]
                                    ['exams'];

                                    var hasItem = false;
                                    var index = (-1);
                                    for (int i = 0;
                                    i <
                                        studentExams
                                            .length;
                                    i++) {
                                      if (studentExams[i]
                                      ['id'] ==
                                          id) {
                                        hasItem = true;
                                        index = i;
                                        break;
                                      }
                                    }
                                    if (hasItem == false) {
                                      studentExams.add({
                                        'id': id,
                                        'exams': exams,
                                        'uniqueId':
                                        uniqueId,
                                        'count': value,
                                      });
                                    } else if (hasItem ==
                                        true) {
                                      for (int i = 0;
                                      i <
                                          studentExams
                                              .length;
                                      i++) {
                                        if (i == index) {
                                          studentExams[i][
                                          'count'] =
                                              value;
                                          studentExams[i][
                                          'exams'] =
                                              exams;
                                        }
                                      }
                                    }

                                    print(studentExams);
                                  },
                                ),
                              )
                                  : Text(
                                  "${examCount(students[i]['exams'])}"),
                            ),
                          ))
                      ],
                    ))
                        : Container(
                      alignment: Alignment.center,
                      height: Get.height * .8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/empty.png',
                            width: 150,
                          ),
                          Text(
                            'Talabalar topilmadi',
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    );
                  }
                  // If no data available

                  else {
                    return Text('No data'); // No data available
                  }
                }),



          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  for (int i = 0; i < studentExams.length; i++) {
                    if (isAlreadyTakenExam(studentExams[i]['exams'])) {
                      studentController.editExam(
                          studentExams[i]['id'],
                          examId(studentExams[i]['exams']),
                          widget.examCount,
                          studentExams[i]['count'],
                          widget.examTitle,
                          widget.examDate);
                    } else {
                      print('also working ... ');
                      studentController.addExam(
                          studentExams[i]['id'],
                          widget.examDate,
                          widget.examCount,
                          studentExams[i]['count'],
                          widget.examTitle);
                    }

                    Future.delayed(Duration(milliseconds: 111));
                  }
                  isEdit.value = false;
                  // And send telegram on pdf format  ...
                  List _students = [];
                  for (var item in students) {
                    int currentExamResult = 0;
                    for (var exam in item['exams']) {
                      if (exam['examDate'] == widget.examDate) {
                        currentExamResult = exam['howMany'].toString().isEmpty
                            ? 0
                            : int.parse(exam['howMany']);
                        break;
                      }
                    }
                    _students.add({
                      'order': "",
                      'name': item['name'],
                      'surname': item['surname'],
                      'grade': currentExamResult,
                      "questionCount": widget.examCount,
                      'percent': double.parse(
                          ((currentExamResult / int.parse(widget.examCount)) *
                              100)
                              .toStringAsFixed(2)),
                      'color': getColor(double.parse(
                          ((currentExamResult / int.parse(widget.examCount)) *
                              100)
                              .toStringAsFixed(2)))
                    });
                  }
                  _students
                      .sort((a, b) => b['percent'].compareTo(a['percent']));
                  for (int i = 0; i < _students.length; i++) {
                    _students[i]['order'] = i + 1;
                  }

                  print("AAA" + _students.toString());

                  examsController.createPdfAndNotify(_students,
                      "${widget.groupName} guruhi ${widget.examTitle} imtihoni natijalari");
                },
                child: Obx(() => CustomButton(
                  text: examsController.createPdf.value ||
                      studentController.isLoading.value
                      ? "Pdf tayyorlanmoqda"
                      : "Pdf Ko'rinishida",
                  color: Colors.green,
                )),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
                child: InkWell(
                    onTap: () async {
                      for (int i = 0; i < studentExams.length; i++) {
                        if (isAlreadyTakenExam(studentExams[i]['exams'])) {
                          studentController.editExam(
                              studentExams[i]['id'],
                              examId(studentExams[i]['exams']),
                              widget.examCount,
                              studentExams[i]['count'],
                              widget.examTitle,
                              widget.examDate);
                        } else {
                          print('also working ... ');
                          studentController.addExam(
                              studentExams[i]['id'],
                              widget.examDate,
                              widget.examCount,
                              studentExams[i]['count'],
                              widget.examTitle);
                        }

                        Future.delayed(Duration(milliseconds: 111));
                      }
                      isEdit.value = false;
                      // And send telegram on pdf format  ...
                      List _students = [];
                      for (var item in students) {
                        int currentExamResult = 0;
                        for (var exam in item['exams']) {
                          if (exam['examDate'] == widget.examDate) {
                            currentExamResult = exam['howMany'].toString().isEmpty
                                ? 0
                                : int.parse(exam['howMany']);
                            break;
                          }
                        }

                        _students.add({
                          'order': "",
                          'name': item['name'],
                          'surname': item['surname'],
                          'grade': currentExamResult,
                          "questionCount": widget.examCount,
                          'percent': double.parse(
                              ((currentExamResult / int.parse(widget.examCount)) *
                                  100)
                                  .toStringAsFixed(2)),
                          'color': getColor(double.parse(
                              ((currentExamResult / int.parse(widget.examCount)) *
                                  100)
                                  .toStringAsFixed(2)))
                        });
                      }
                      _students
                          .sort((a, b) => b['percent'].compareTo(a['percent']));
                      for (int i = 0; i < _students.length; i++) {
                        _students[i]['order'] = i + 1;
                      }


                      examProcess.value = false;
                       
                      Get.to(ExamResultsAsImg(examResults: _students));
                    },
                    child: Obx(()=>CustomButton(text: examProcess.value ? "Tayyorlanyapti":"Rasm ko'rinishida"))))
          ],
        ),
      ),
    );
  }
}
