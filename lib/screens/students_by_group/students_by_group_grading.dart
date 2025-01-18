import 'dart:io';

import 'package:leader/controllers/grade_controller/grade_controller.dart';
import 'package:leader/screens/students_by_group/grading_students.dart';
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

class Grading extends StatelessWidget {
  final String groupId;
  final String groupName;
   final String gradeDate;
  final String gradeTime;

  Grading({
    required this.groupId,
    required this.groupName,
     required this.gradeDate,
    required this.gradeTime,
  });

  GetStorage box = GetStorage();

  RxList students = [].obs;

  RxBool gradeProcess = false.obs;

  RxList studentGrading = [].obs;

  bool isAlreadyGraded(List list) {
    bool hasTaken = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['time'] == gradeTime && list[i]['date'] == gradeDate) {
        hasTaken = true;
        break;
      }
    }
    return hasTaken;
  }

  String gradeId(List list) {
    String examId = '';
    for (int i = 0; i < list.length; i++) {
      if (list[i]['time'] == gradeTime && list[i]['date'] == gradeDate) {
        examId = list[i]['id'];
        break;
      }
    }
    return examId;
  }

  String grade(List list) {
    String grade = '';
    for (int i = 0; i < list.length; i++) {
      if (list[i]['time'] == gradeTime && list[i]['date'] == gradeDate) {
        grade = "${list[i]['grade']}";
        break;
      }
    }
    return grade;
  }

  RxBool isEdit = false.obs;

  GradeController gradeController = Get.put(GradeController());

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        title: Text(gradeDate),
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
                    .where('items.groupId', isEqualTo: groupId)
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
                        'grades': list[i]['items']['grades'],
                        'id': list[i].id,
                        'surname': list[i]['items']['surname'],
                       });
                    }
                    students .sort((a, b) => (a['surname']).compareTo(b['surname']));

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
                                                  '${students[i]['name'].toString().capitalizeFirst} ${students[i]['surname'].toString().capitalizeFirst}')
                                            ],
                                          ),
                                          trailing: isAlreadyGraded(students[i] ['grades'] ?? []) ==
                                                      false ||
                                                  isEdit == true
                                              ? SizedBox(
                                                  width: Get.width / 10,
                                                  child: TextFormField(
                                                    buildCounter: (context,
                                                        {required int
                                                            currentLength,
                                                        required bool isFocused,
                                                        required int?
                                                            maxLength}) {
                                                      return null; // Hides the counter
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: '',
                                                    ),
                                                    minLines: 1,
                                                    maxLength: 3,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      // Allow only numbers
                                                      MaxValueInputFormatter(
                                                          100),
                                                      // Custom formatter for max value
                                                    ],
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
                                                      var id = students[i]['id'];

                                                      var grades = students[i]['grades'];

                                                      var hasItem = false;
                                                      var index = (-1);
                                                      for (int i = 0;
                                                          i <
                                                              studentGrading
                                                                  .length;
                                                          i++) {
                                                        if (studentGrading[i]
                                                                ['id'] ==
                                                            id) {
                                                          hasItem = true;
                                                          index = i;
                                                          break;
                                                        }
                                                      }
                                                      if (hasItem == false) {
                                                        studentGrading.add({
                                                          'id': id,
                                                          'grades': grades,

                                                          'grade': value,
                                                        });
                                                      } else if (hasItem ==
                                                          true) {
                                                        for (int i = 0;
                                                            i <
                                                                studentGrading
                                                                    .length;
                                                            i++) {
                                                          if (i == index) {
                                                            studentGrading[i]
                                                                    ['grade'] =
                                                                value;
                                                            studentGrading[i]
                                                                    ['grades'] =
                                                                grades;
                                                          }
                                                        }
                                                      }

                                                      print(studentGrading);
                                                    },
                                                  ),
                                                )
                                              : Text(
                                                  "${grade(students[i]['grades'])}"),
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
        child: InkWell(
          onTap: () {
            gradeProcess.value = true;
            for (int i = 0; i < studentGrading.length; i++) {
              if (isAlreadyGraded(studentGrading[i]['grades'] ?? [])) {
                gradeController.editGrading(
                  gradeId(studentGrading[i]['grades']),
                  studentGrading[i]['id'],
                  gradeDate,
                  gradeTime,
                  studentGrading[i]['grade'],
                );

                Get.back();
                Get.to(Grading(groupId: groupId, groupName: groupName, gradeDate: gradeDate, gradeTime: gradeTime,));
              } else {
                print('also working ... ');
                gradeController.addGrade(studentGrading[i]['id'], gradeDate,
                    gradeTime, studentGrading[i]['grade']);
              }

            }
            gradeProcess.value = false;



          },
          child: Obx(()=>CustomButton(
            text:gradeProcess.value == true? "Saqlanyapti" : "Saqlash",
            color: Colors.green,
          )),
        ),
      ),
    );
  }
}
