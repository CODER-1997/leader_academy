import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/constants/custom_widgets/emptiness.dart';
import 'package:leader/controllers/exams/exams_controller.dart';
import 'package:leader/screens/students_by_group/additional_funcs/add_exams.dart';
import 'package:leader/screens/students_by_group/students_by_group_cefr.dart';
import 'package:leader/screens/students_by_group/students_by_group_exams.dart';
import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';

class Exams extends StatelessWidget {
  final String group;
  final String groupId;
  final String subject;

  Exams({
    required this.group,
    required this.groupId,
    required this.subject,
  });

  final _formKey = GlobalKey<FormState>();

  ExamsController examController = Get.put(ExamsController());
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffe8e8e8),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LeaderExams')
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
                var exams = snapshot.data!.docs;

                return exams.isNotEmpty
                    ? ListView.builder(
                        itemCount: exams.length,
                        itemBuilder: (context, index) {
                          var exam = exams[index];
                          return GestureDetector(
                            onTap: () {
                              if (box.read('exam_text') == null) {
                                box.write('exam_text',
                                    "Farzandingiz #ismi #fam #fan #guruh imtihonidan #foiz oldi . #sana");
                              }
                              if (exam['items']['isCefr'] == true) {
                                Get.to(Cefr(
                                  groupId: groupId,
                                  groupName: group,
                                  examTitle: exam['items']['name'],
                                  examCount: exam['items']['questionNums'],
                                  examDate: exam['items']['date'],
                                ));
                              } else {
                                Get.to(ExamResults(
                                  groupId: groupId,
                                  groupName: group,
                                  examTitle: exam['items']['name'],
                                  examCount: exam['items']['questionNums'],
                                  examDate: exam['items']['date'],
                                  subject: subject,
                                  isTestTypeExam: exam['items']['isTestType'],
                                  examDocId: exam.id,
                                ));
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              margin: EdgeInsets.all(4),
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              examController.setValues(
                                                exam['items']['name'],
                                                exam['items']['questionNums'],
                                              );

                                              return Dialog(
                                                backgroundColor: Colors.white,
                                                insetPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 16),

                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0)),
                                                //this right here
                                                child: Form(
                                                  key: _formKey,
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12)),
                                                    width: Get.width,
                                                    height: exam['items']
                                                                ['isCefr'] ==
                                                            true
                                                        ? Get.height / 3.8
                                                        : Get.height / 2.2,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text("Tahrirlash"),
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                            SizedBox(
                                                              child:
                                                                  TextFormField(
                                                                      decoration:
                                                                          buildInputDecoratione(
                                                                              ''),
                                                                      controller:
                                                                          examController
                                                                              .examEdit,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .text,
                                                                      validator:
                                                                          (value) {
                                                                        if (value!
                                                                            .isEmpty) {
                                                                          return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                        }
                                                                        return null;
                                                                      }),
                                                            ),
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                            exam['items'][
                                                                        'isCefr'] ==
                                                                    true
                                                                ? SizedBox()
                                                                : TextFormField(
                                                                    decoration:
                                                                        buildInputDecoratione(
                                                                            ''),
                                                                    controller:
                                                                        examController
                                                                            .examQuestionCountEdit,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                      }
                                                                      return null;
                                                                    }),
                                                            SizedBox(
                                                              height: 16,
                                                            ),
                                                          ],
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              examController
                                                                  .editExam(exam
                                                                      .id
                                                                      .toString());
                                                            }
                                                          },
                                                          child: Obx(() => CustomButton(
                                                              isLoading:
                                                                  examController
                                                                      .isLoading
                                                                      .value,
                                                              text:
                                                                  "Tahrirlash")),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "O'chirish",
                                            middleText:
                                                "Rostdanham o'chirilsinmi ?",
                                            textCancel: "Yoq",
                                            textConfirm: "Ha",
                                            confirmTextColor: Colors.white,
                                            onConfirm: () {
                                              examController
                                                  .deleteExam(exam.id);
                                            },
                                            onCancel: () {},
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${exam['items']['name']}'),
                                    exam['items']['isWarned'] == true
                                        ? Row(
                                          children: [
                                            Text(
                                                "Ogohlantirilgan",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w900),
                                              ),
                                            exam['items']['warnedTime']!=null  ?
                                            Text(
                                              "   (${ exam['items']['warnedTime']})",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w900),
                                            ):SizedBox()
                                          ],
                                        )
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Emptiness(title: 'Hali imtihonlar yo\'q');
              }
              // If no data available

              else {
                return Text('Malumot mavjud emas'); // No data available
              }
            }),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: AddExams(group: group, groupId: groupId,),
    );
  }
}
