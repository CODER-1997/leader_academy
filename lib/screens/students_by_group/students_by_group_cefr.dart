
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/utils.dart';
 import '../../constants/custom_widgets/gradient_button.dart';
import '../../constants/form_field.dart';
import '../../constants/utils.dart';
import '../../controllers/exams/exams_controller.dart';
import '../../controllers/students/student_controller.dart';
import 'cefr_exam_as_img.dart';

class Cefr extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String examTitle;
  final String examCount;
  final String examDate;

  Cefr({
    required this.groupId,
    required this.groupName,
    required this.examTitle,
    required this.examCount,
    required this.examDate,
  });

  @override
  State<Cefr> createState() => _CefrState();
}

class _CefrState extends State<Cefr> {
  StudentController studentController = Get.put(StudentController());

  GetStorage box = GetStorage();

  RxList students = [].obs;
  RxBool messageLoader = false.obs;

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
                                        margin:
                                            EdgeInsets.symmetric(vertical: .5),
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
                                                  '${students[i]['surname'].toString().capitalizeFirst} ${students[i]['name'].toString().substring(0, 3).capitalizeFirst! + '...'}')
                                            ],
                                          ),
                                          trailing: isAlreadyTakenExam(
                                                          students[i]
                                                              ['exams']) ==
                                                      false ||
                                                  isEdit == true
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  // Ensures the Row takes only as much space as needed

                                                  children: [
                                                    SizedBox(
                                                      width: Get.width / 8,
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
                                                        decoration: InputDecoration(
                                                            hintText: 'Reading',
                                                            hintStyle: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 8)),
                                                        minLines: 1,
                                                        maxLength: 3,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                          // Allow only numbers
                                                          MaxValueInputFormatter(
                                                              35),
                                                          // Custom formatter for max value
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          var id =  students[i]['id'];
                                                          var uniqueId = students[i] ['uniqueId'];
                                                          var exams = students[i] ['exams'];

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
                                                          if (hasItem ==
                                                              false) {
                                                            studentExams.add({
                                                              'id': id,
                                                              'exams': exams,
                                                              'uniqueId':
                                                                  uniqueId,
                                                              'reading': value,
                                                            });
                                                          } else if (hasItem ==
                                                              true) {
                                                            for (int i = 0;
                                                                i <
                                                                    studentExams
                                                                        .length;
                                                                i++) {
                                                              if (i == index) {
                                                                studentExams[i][ 'reading'] = value;
                                                                studentExams[i][ 'exams'] = exams;
                                                              }
                                                            }
                                                          }

                                                          print(studentExams);
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    SizedBox(
                                                      width: Get.width / 8,
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
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                'Listening',
                                                            hintStyle: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 8)),
                                                        minLines: 1,
                                                        maxLength: 3,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                          // Allow only numbers
                                                          MaxValueInputFormatter(
                                                              35),
                                                          // Custom formatter for max value
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          var id =
                                                              students[i]['id'];
                                                          var uniqueId =
                                                              students[i]
                                                                  ['uniqueId'];
                                                          var exams =
                                                              students[i]
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
                                                          if (hasItem ==
                                                              false) {
                                                            studentExams.add({
                                                              'id': id,
                                                              'exams': exams,
                                                              'uniqueId':
                                                                  uniqueId,
                                                              'listening':
                                                                  value,
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
                                                                        'listening'] =
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
                                                    ),
                                                  ],
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
                          '35',
                          studentExams[i]['reading'] +
                              "@" +
                              studentExams[i]['listening'],                    widget.examTitle,
                          widget.examDate);
                    } else {
                      print('also working ... ');
                      studentController.addExam(
                          studentExams[i]['id'],
                          widget.examDate,
                          '35',
                          studentExams[i]['reading'] +
                              "@" +
                              studentExams[i]['listening'],
                          widget.examTitle);
                    }

                    Future.delayed(Duration(milliseconds: 111));
                  }
                  isEdit.value = false;
                  // And send telegram on pdf format  ...
                  List _students = [];
                  for (var item in students) {
                    var currentExamResult = "";
                    for (var exam in item['exams']) {
                       if (exam['examDate'] == widget.examDate  ) {
                        currentExamResult = exam['howMany'].toString().isEmpty || exam['howMany'].toString().length < 3
                            ? "0@0"
                            : exam['howMany'];
                        break;
                      }
                       else {
                         continue;
                       }

                    }

                   if(currentExamResult.length >=3){
                     _students.add({
                       'name': item['name'],
                       'surname': item['surname'],
                       'reading':ceftReading(int.parse( currentExamResult.toString().split('@')[0])),
                       'listening':ceftListening(int.parse( currentExamResult.toString().split('@')[1])),
                       'overall':(ceftReading(int.parse( currentExamResult.toString().split('@')[0])) + ceftListening(int.parse( currentExamResult.toString().split('@')[1])))/2,
                       'color':getCefrBandColor(double.parse(((ceftReading(int.parse( currentExamResult.toString().split('@')[0])) + ceftListening(int.parse( currentExamResult.toString().split('@')[1])))/2).toString())),
                       'cefr_band':getCefrBand(double.parse(((ceftReading(int.parse( currentExamResult.toString().split('@')[0])) + ceftListening(int.parse( currentExamResult.toString().split('@')[1])))/2).toString()))

                     });
                   }


                  }
                  print("Final Result" + _students.toString());

                  _students.sort((a, b) => b['overall'].compareTo(a['overall']));


                  examsController.createPdfAndNotifyIelts(_students,
                      "${widget.groupName} guruhi ${widget.examTitle} imtihoni natijalari");
                },
                child: Obx(() => CustomButton(
                      text: examsController.createPdf.value ||
                              studentController.isLoading.value
                          ? "Pdf tayyorlanmoqda"
                          : "Saqlash",
                      color: Colors.green,
                    )),
              ),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: InkWell(
                onTap: () {
                  for (int i = 0; i < studentExams.length; i++) {
                    if (isAlreadyTakenExam(studentExams[i]['exams'])) {
                      studentController.editExam(
                          studentExams[i]['id'],
                          examId(studentExams[i]['exams']),
                          '35',
                          studentExams[i]['reading'] +
                              "@" +
                              studentExams[i]['listening'],                    widget.examTitle,
                          widget.examDate);
                    } else {
                      print('also working ... ');
                      studentController.addExam(
                          studentExams[i]['id'],
                          widget.examDate,
                          '35',
                          studentExams[i]['reading'] +
                              "@" +
                              studentExams[i]['listening'],
                          widget.examTitle);
                    }

                    Future.delayed(Duration(milliseconds: 111));
                  }
                  isEdit.value = false;
                  // And send telegram on pdf format  ...
                  List _students = [];
                  for (var item in students) {
                    var currentExamResult = "";
                    for (var exam in item['exams']) {
                       if (exam['examDate'] == widget.examDate  ) {
                        currentExamResult = exam['howMany'].toString().isEmpty || exam['howMany'].toString().length < 3
                            ? "0@0"
                            : exam['howMany'];
                        break;
                      }
                       else {
                         continue;
                       }

                    }

                   if(currentExamResult.length >=3){
                     _students.add({
                       'order':"",
                       'name': item['name'],
                       'surname': item['surname'],
                       'reading':ceftReading(int.parse( currentExamResult.toString().split('@')[0])),
                       'listening':ceftListening(int.parse( currentExamResult.toString().split('@')[1])),
                       'overall':(ceftReading(int.parse( currentExamResult.toString().split('@')[0])) + ceftListening(int.parse( currentExamResult.toString().split('@')[1])))/2,
                       'color':getCefrBandColor(double.parse(((ceftReading(int.parse( currentExamResult.toString().split('@')[0])) + ceftListening(int.parse( currentExamResult.toString().split('@')[1])))/2).toString())),
                       'cefr_band':getCefrBand(double.parse(((ceftReading(int.parse( currentExamResult.toString().split('@')[0])) + ceftListening(int.parse( currentExamResult.toString().split('@')[1])))/2).toString()))

                     });
                   }


                  }
                  print("Final Result" + _students.toString());

                  _students.sort((a, b) => b['overall'].compareTo(a['overall']));

                  for(int i = 0 ; i  < _students.length;i++){
                    _students[i]['order'] = "${i+1}";
                  }

                  Get.to(CefrResultsAsImg(examResults: _students));



                },
                child:  CustomButton(
                      text:   "Rasm ko'rinishida",
                      color: Colors.blue,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
