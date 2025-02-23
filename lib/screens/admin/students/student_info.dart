import 'package:get_storage/get_storage.dart';
import 'package:leader/screens/admin/students/exams.dart';
import 'package:leader/screens/admin/students/unpaid_months.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leader/screens/admin/students/student_payment_history.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/custom_dialog.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';
import '../statistics/calendar_view.dart';

class StudentInfo extends StatefulWidget {
  final String studentId;
  final String subject;

  StudentInfo({required this.studentId, required this.subject});

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  final _formKey = GlobalKey<FormState>();

  StudentController studentController = Get.put(StudentController());

  String swipeDirection = 'Swipe me!';
  GetStorage box = GetStorage();

  void _detectSwipe(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      setState(() => Get.back());
    } else if (details.delta.dx < 0) {
      setState(() => swipeDirection = 'Swiping Left');
    } else if (details.delta.dy > 0) {
      setState(() => swipeDirection = 'Swiping Down');
    } else if (details.delta.dy < 0) {
      setState(() => swipeDirection = 'Swiping Up');
    }
  }
  String calculateAverage(List exams) {
    dynamic val = 0;
     if(exams.isNotEmpty){

      for(int i = 0 ; i < exams.length ; i++){
        val += int.parse(exams[i]['howMany'].toString().isNotEmpty ? exams[i]['howMany'].toString():'0') * 100/int.parse(exams[i]['from']);
      }
      val   = val/exams.length;
      return  "O'rtacha: ${val.toString().substring(0,2)} %";

    }
    return  'Baholanmagan';

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _detectSwipe,

      child: Scaffold(
        backgroundColor: homePagebg,
        appBar: AppBar(
          backgroundColor: dashBoardColor,
          leading: IconButton(
            onPressed: Get.back,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: true,
          title: Text(
            "Student profil",
            style: appBarStyle.copyWith(color: Colors.white),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: getDocumentStreamById('LeaderStudents', widget.studentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Document not found');
            } else {
              // Access the document data
              Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
              studentController.isFreeOfCharge.value =
                  data['items']['isFreeOfcharge'] ?? false;
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () {
                          studentController.fetchGroups();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              studentController.setValues(
                                data['items']['name'],
                                data['items']['surname'],
                                data['items']['phone'],
                              );
                              studentController.startedDay.value =
                              data['items']['startedDay'];
                              studentController.selectedGroupId.clear();

                              for (var item in data['items']['groups']) {
                                studentController.selectedGroupId.add(
                                    item['groupId']);
                              }

                              return Dialog(
                                backgroundColor: Colors.white,
                                insetPadding: EdgeInsets.all(0),

                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                //this right here
                                child: Form(
                                  key: _formKey,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            12)),
                                    width: Get.width,
                                    height: Get.height,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Text("Tahrirlash"),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              SizedBox(
                                                child: TextFormField(
                                                    decoration:
                                                    buildInputDecoratione(''),
                                                    controller: studentController
                                                        .nameEdit,
                                                    keyboardType:
                                                    TextInputType.text,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Maydonlar bo'sh bo'lmasligi kerak";
                                                      }
                                                      return null;
                                                    }),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              SizedBox(
                                                child: TextFormField(
                                                  controller: studentController
                                                      .surnameEdit,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Maydonlar bo'sh bo'lmasligi kerak";
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                  buildInputDecoratione(''
                                                      .tr
                                                      .capitalizeFirst! ??
                                                      ''),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              SizedBox(
                                                child: TextFormField(
                                                  controller:
                                                  studentController.phoneEdit,
                                                  // validator:
                                                  //     (value) {
                                                  //   if (value!.isEmpty) {
                                                  //     return "Maydonlar bo'sh bo'lmasligi kerak";
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  decoration:
                                                  buildInputDecoratione('Phone'
                                                      .tr
                                                      .capitalizeFirst! ??
                                                      ''),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Row(
                                                children: [
                                                  Obx(
                                                        () =>
                                                        Text(
                                                            'Kelgan kuni:  ${studentController
                                                                .startedDay
                                                                .value}'),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        studentController
                                                            .showDate2(
                                                            studentController
                                                                .startedDay);
                                                      },
                                                      icon: Icon(
                                                          Icons.calendar_month))
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Guruhlar',
                                                    style: appBarStyle,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 16,
                                              ),
                                              Obx(() =>
                                                  Container(
                                                    alignment: Alignment
                                                        .topLeft,
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                      Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          for (int i = 0; i <
                                                              studentController
                                                                  .LeaderGroups
                                                                  .length; i++)
                                                            GestureDetector(
                                                              onTap: () {
                                                                if (studentController
                                                                    .selectedGroupId
                                                                    .contains(
                                                                    studentController
                                                                        .LeaderGroups[i]['group_id'])) {
                                                                  studentController
                                                                      .selectedGroupId
                                                                      .removeWhere((
                                                                      el) =>
                                                                  el ==
                                                                      studentController
                                                                          .LeaderGroups[i]
                                                                      [
                                                                      'group_id']);
                                                                } else {
                                                                  studentController
                                                                      .selectedGroupId
                                                                      .add(
                                                                      studentController
                                                                          .LeaderGroups[i]
                                                                      [
                                                                      'group_id']);
                                                                }
                                                                print(
                                                                    studentController
                                                                        .selectedGroupId);
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    18,
                                                                    vertical:
                                                                    8),
                                                                margin: EdgeInsets
                                                                    .all(8),
                                                                decoration: studentController
                                                                    .selectedGroupId
                                                                    .contains(
                                                                    studentController
                                                                        .LeaderGroups[i]['group_id']) ==
                                                                    false
                                                                    ? BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        112),
                                                                    border: Border
                                                                        .all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                        1))
                                                                    : BoxDecoration(
                                                                    color: Colors
                                                                        .green,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        112),
                                                                    border: Border
                                                                        .all(
                                                                        color:
                                                                        Colors
                                                                            .green,
                                                                        width: 1)),
                                                                child: Text(
                                                                  "${studentController
                                                                      .LeaderGroups[i]['group_name']}",
                                                                  style: TextStyle(
                                                                      color: studentController
                                                                          .selectedGroupId
                                                                          .contains(
                                                                          studentController
                                                                              .LeaderGroups[i]['group_id']) ==
                                                                          false
                                                                          ? Colors
                                                                          .black
                                                                          : CupertinoColors
                                                                          .white),
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Obx(() =>
                                                      InkWell(
                                                        onTap: () {
                                                          studentController
                                                              .isFreeOfCharge
                                                              .value =
                                                          !studentController
                                                              .isFreeOfCharge
                                                              .value;
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                              horizontal: 18,
                                                              vertical: 8),
                                                          margin:
                                                          EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                              color: studentController
                                                                  .isFreeOfCharge
                                                                  .value
                                                                  ? Colors.green
                                                                  : Colors
                                                                  .white,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  112),
                                                              border: Border
                                                                  .all(
                                                                  color: Colors
                                                                      .green,
                                                                  width: 1)),
                                                          child: Text(
                                                            "is free of charge",
                                                            style: TextStyle(
                                                              color: studentController
                                                                  .isFreeOfCharge
                                                                  .value
                                                                  ? Colors.white
                                                                  : Colors
                                                                  .black,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: Get.height / 5,
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    studentController
                                                        .selectedGroups.clear();
                                                    for (var item in studentController
                                                        .selectedGroupId) {
                                                      for (var lg in studentController
                                                          .LeaderGroups) {
                                                        if (item ==
                                                            lg['group_id']) {
                                                          if (!studentController
                                                              .selectedGroups
                                                              .contains({
                                                            'subject': lg['subject'],
                                                            'groupId': lg['group_id']
                                                          })) {
                                                            studentController
                                                                .selectedGroups
                                                                .add({
                                                              'subject': lg['subject'],
                                                              'groupId': lg['group_id']
                                                            });
                                                          }
                                                          break;
                                                        }
                                                      }
                                                    }
                                                    print("selections" +
                                                        studentController
                                                            .selectedGroups
                                                            .toString());


                                                    studentController
                                                        .editStudent(
                                                        widget.studentId);
                                                  }
                                                },
                                                child: Obx(() =>
                                                    CustomButton(
                                                        isLoading: studentController
                                                            .isLoading.value,
                                                        text: "Tahrirlash"
                                                            .tr
                                                            .capitalizeFirst!)),
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: CustomButton(
                                                    color: Colors.red,
                                                    text: "Yopish"
                                                        .tr
                                                        .capitalizeFirst!),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      contentPadding: EdgeInsets.all(8),
                      leading: Image.asset(
                        'assets/student_avatar.png',
                        width: 64,
                      ),
                      subtitle: Text("Id: ${data['items']['uniqueId']}"),
                      title: Text(
                        "${data['items']['name']}".capitalizeFirst! +
                            "   " +
                            "${data['items']['surname']}".capitalizeFirst!,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: box.read('isLogged') == '004422' ? 2 : 0,
                  ),
                  box.read('isLogged') == '004422' ? InkWell(
                    onTap: () {
                      if (data['items']['isFreeOfcharge'] == false) {
                        Get.to(AdminStudentPaymentHistory(
                          uniqueId: '${data['items']['uniqueId']}',
                          id: widget.studentId,
                          name: data['items']['name'],
                          surname: data['items']['surname'],
                          paidMonths: data['items']['payments'],
                          yeralyFee: data['items']['yeralyFee'].toString(),
                          paymentType: data['items']['paymentType'],
                          subject: widget.subject,
                        ));
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Image.asset(
                          'assets/gold_bill.png',
                          width: 64,
                        ),
                        title: Text(
                          data['items']['isFreeOfcharge'] == false
                              ? "Payment history".capitalizeFirst!
                              : "Free of charge",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ) : SizedBox(),
                  SizedBox(
                    height: 2,
                  ),
                  calculateUnpaidMonths(data['items']['studyDays'],
                      data['items']['payments'], widget.subject)
                      .length !=
                      0
                      ? InkWell(
                    onTap: () {
                      Get.to(UnpaidMonths(
                        months: calculateUnpaidMonths(
                            data['items']['studyDays'],
                            data['items']['payments'],
                            widget.subject),
                        studentPhone: data['items']['phone'],
                        studentName: data['items']['name'],
                        studentSurname: data['items']['surname'],
                      ));
                    },
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Image.asset(
                          'assets/debt.png',
                          width: 64,
                        ),
                        title: Row(
                          children: [
                            Text(
                              "Unpaid months".capitalizeFirst!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 12),
                              alignment: Alignment.center,
                              width: 33,
                              height: 33,
                              child: Text(
                                "${calculateUnpaidMonths(
                                    data['items']['studyDays'],
                                    data['items']['payments'], widget.subject)
                                    .length}",
                                style: TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(121)),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),
                  calculateUnpaidMonths(data['items']['studyDays'],
                      data['items']['payments'], widget.subject)
                      .length !=
                      0
                      ? SizedBox(
                    height: 2,
                  )
                      : SizedBox(),

                  InkWell(
                    onTap: () {
                      var list = [];

                      for (int i = 0;
                      i < data['items']['studyDays'].length;
                      i++) {
                        if (data['items']['studyDays'][i]['hasReason']
                            .isNotEmpty) {
                          list.add({
                            'isAttended': data['items']['studyDays'][i]
                            ['isAttended'],
                            'comment': data['items']['studyDays'][i]['hasReason']
                            ['commentary'],
                            'day': DateFormat('dd-MM-yyyy')
                                .parse(
                                data['items']['studyDays'][i]['studyDay'])
                          });
                        } else {
                          list.add({
                            'isAttended': data['items']['studyDays'][i]
                            ['isAttended'],
                            'comment': data['items']['studyDays'][i]['hasReason']
                            ['commentary'],
                            'day': DateFormat('dd-MM-yyyy')
                                .parse(
                                data['items']['studyDays'][i]['studyDay'])
                          });
                        }
                      }
                      Get.to(CalendarScreen(
                        days: list,
                      ));
                    },
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Image.asset(
                          'assets/calendar.png',
                          width: 64,
                        ),
                        title: Text(
                          "Kelgan kunlari".capitalizeFirst!,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),

                  InkWell(
                    onTap: () {
                      Get.to(AdminStudentExam(
                          uniqueId: data['items']['uniqueId'],
                          id: widget.studentId,
                          name: data['items']['name'],
                          surname: data['items']['surname']));
                    },
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Image.asset(
                          'assets/exams2.png',
                          width: 64,
                        ),
                        title: Text(
                          "Imtihon natijalari".capitalizeFirst!,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w700),
                        ),
                        trailing: Text(calculateAverage(data['items']['exams'])),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomAlertDialog(
                                title: "Talabani o'chirish",
                                description:
                                "Rostdanham o'chirasizmi ?",
                                onConfirm: () async {
                                  // Perform delete action here
                                  studentController.deleteStudent(
                                      widget.studentId);
                                  Get.back();
                                },
                                img: 'assets/delete.png',
                              ),
                              Obx(() =>
                              studentController.isLoading.value
                                  ? Container(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white),
                                padding: EdgeInsets.all(32),
                              )
                                  : SizedBox())
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          "Talabani o'chirish".capitalizeFirst!,
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  // data['items']['phone'].toString().isNotEmpty?    InkWell(
                  //   onTap: () {
                  //
                  //   },
                  //   child: Container(
                  //     color: Colors.white,
                  //     child: ListTile(
                  //       contentPadding: EdgeInsets.all(8),
                  //       leading: Icon(
                  //         Icons.call,
                  //         color: Colors.green,
                  //       ),
                  //       title: Text(
                  //         "Call student".capitalizeFirst!,
                  //         style: TextStyle(
                  //             color: Colors.green, fontWeight: FontWeight.w700),
                  //       ),
                  //     ),
                  //   ),
                  // ):SizedBox()
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

Stream<DocumentSnapshot> getDocumentStreamById(String collection,
    String documentId) {
  DocumentReference documentRef =
  FirebaseFirestore.instance.collection(collection).doc(documentId);
  return documentRef.snapshots();
}
