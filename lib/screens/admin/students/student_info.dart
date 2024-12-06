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

class StudentInfo extends StatelessWidget {
  final String studentId;
  final _formKey = GlobalKey<FormState>();

  StudentController studentController = Get.put(StudentController());

  StudentInfo({required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        stream: getDocumentStreamById('LeaderStudents', studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text('Document not found');
          } else {
            // Access the document data
            Map<String, dynamic> data =  snapshot.data!.data() as Map<String, dynamic>;
            studentController
                .isFreeOfCharge
                .value =
            data['items']['isFreeOfcharge'] ?? false;
            return Column(
              children: [
                Container(
                  color: Colors.white,
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        studentController.fetchGroups();
                        studentController.selectedGroupId.value =
                        data['items']['groupId'];
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            studentController.setValues(
                              data['items']['name'],
                              data['items']['surname'],
                              data['items']['phone'],
                            );

                            return Dialog(
                              backgroundColor: Colors.white,
                              insetPadding:
                              EdgeInsets.symmetric(horizontal: 16),

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0)),
                              //this right here
                              child: Form(
                                key: _formKey,
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  width: Get.width,
                                  height: Get.height / 1.4,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Edit student info"),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          SizedBox(
                                            child: TextFormField(
                                                decoration:
                                                buildInputDecoratione(''),
                                                controller:
                                                studentController.nameEdit,
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
                                              controller:
                                              studentController.surnameEdit,
                                              keyboardType: TextInputType.text,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Maydonlar bo'sh bo'lmasligi kerak";
                                                }
                                                return null;
                                              },
                                              decoration: buildInputDecoratione(
                                                  ''.tr.capitalizeFirst! ?? ''),
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
                                              decoration: buildInputDecoratione(
                                                  'Phone'.tr.capitalizeFirst! ??
                                                      ''),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            children: [
                                              Obx(
                                                    () => Text(
                                                    'Started date:  ${studentController.paidDate.value}'),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    studentController.showDate(
                                                        studentController
                                                            .paidDate);
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
                                                'Choose Group',
                                                style: appBarStyle,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Obx(() => Container(
                                            alignment: Alignment.topLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection:
                                              Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  for (int i = 0;
                                                  i <
                                                      studentController
                                                          .LeaderGroups
                                                          .length;
                                                  i++)
                                                    GestureDetector(
                                                      onTap: () {

                                                        studentController
                                                            .selectedGroup
                                                            .value = studentController
                                                            .LeaderGroups[
                                                        i]['group_name'];
                                                        studentController
                                                            .selectedGroupId
                                                            .value = studentController
                                                            .LeaderGroups[
                                                        i]['group_id'];

                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            18,
                                                            vertical:
                                                            8),
                                                        margin:
                                                        EdgeInsets.all(
                                                            8),
                                                        decoration: studentController
                                                            .selectedGroupId
                                                            .value !=
                                                            studentController
                                                                .LeaderGroups[i]
                                                            [
                                                            'group_id']
                                                            ? BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                112),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black,
                                                                width:
                                                                1))
                                                            : BoxDecoration(
                                                            color: Colors
                                                                .green,
                                                            borderRadius:
                                                            BorderRadius.circular(112),
                                                            border: Border.all(color: Colors.green, width: 1)),
                                                        child: Text(
                                                          "${studentController.LeaderGroups[i]['group_name']}",
                                                          style: TextStyle(
                                                              color: studentController
                                                                  .selectedGroupId.value !=
                                                                  studentController.LeaderGroups[i]
                                                                  [
                                                                  'group_id']
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
                                              Obx(() => InkWell(
                                                onTap: () {
                                                  studentController
                                                      .isFreeOfCharge
                                                      .value = !studentController
                                                      .isFreeOfCharge
                                                      .value ;
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 8),
                                                  margin: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                      color: studentController
                                                          .isFreeOfCharge
                                                          .value
                                                          ? Colors.green
                                                          : Colors.white,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          112),
                                                      border: Border.all(
                                                          color: Colors.green,
                                                          width: 1)),
                                                  child: Text(
                                                    "is free of charge",
                                                    style: TextStyle(
                                                      color: studentController
                                                          .isFreeOfCharge
                                                          .value
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              )),
                                            ],
                                          )
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            studentController
                                                .editStudent(studentId);
                                          }
                                        },
                                        child: Obx(() => CustomButton(
                                            isLoading: studentController
                                                .isLoading.value,
                                            text: "Edit".tr.capitalizeFirst!)),
                                      )
                                    ],
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
                  height: 2,
                ),
                InkWell(
                  onTap: () {
                    if(  data['items']['isFreeOfcharge']  == false){
                      Get.to(AdminStudentPaymentHistory(
                        uniqueId: '${data['items']['uniqueId']}',
                        id: studentId,
                        name: data['items']['name'],
                        surname: data['items']['surname'],
                        paidMonths:data['items']['payments'],
                        yeralyFee: data['items']['yeralyFee'].toString(), paymentType:data['items']['paymentType'] ,
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
                        data['items']['isFreeOfcharge']  == false ?    "Payment history".capitalizeFirst!:"Free of charge",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                calculateUnpaidMonths(data['items']['studyDays'],
                    data['items']['payments'])
                    .length !=
                    0
                    ? InkWell(
                  onTap: () {
                    Get.to(UnpaidMonths(
                      months: calculateUnpaidMonths(
                          data['items']['studyDays'],
                          data['items']['payments']),
                      studentPhone: data['items']['phone'],
                      studentName: data['items']['name'], studentSurname: data['items']['surname'],
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
                              "${calculateUnpaidMonths(data['items']['studyDays'], data['items']['payments']).length}",
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
                    data['items']['payments'])
                    .length !=
                    0
                    ? SizedBox(
                  height: 2,
                )
                    : SizedBox(),






                InkWell(
                  onTap: () {
                    var list = [];

                    for (int i = 0; i < data['items']['studyDays'].length; i++) {
                      if(data['items']['studyDays'][i]['hasReason'].isNotEmpty ){
                        list.add({
                          'isAttended':data['items']['studyDays'][i]['isAttended'],
                          'comment':data['items']['studyDays'][i]['hasReason']['commentary'],
                          'day': DateFormat('dd-MM-yyyy').parse(data['items']['studyDays'][i]['studyDay'])
                        });
                      }
                      else {
                        list.add({
                          'isAttended':data['items']['studyDays'][i]['isAttended'],
                          'comment':data['items']['studyDays'][i]['hasReason']['commentary'],
                          'day': DateFormat('dd-MM-yyyy').parse(data['items']['studyDays'][i]['studyDay'])

                        });
                      }

                    }
                    Get.to(CalendarScreen(days: list, ));
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
                        "Attended days".capitalizeFirst!,
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomAlertDialog(
                              title: "Delete Student",
                              description:
                              "Are you sure you want to delete this student?",
                              onConfirm: () async {
                                // Perform delete action here
                                studentController.deleteStudent(studentId);
                                Get.back();
                              },
                              img: 'assets/delete.png',
                            ),
                            Obx(() => studentController.isLoading.value
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
                        "Delete student".capitalizeFirst!,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 2,
                // ),
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

    );
  }
}

Stream<DocumentSnapshot> getDocumentStreamById(
    String collection, String documentId) {
  DocumentReference documentRef =
  FirebaseFirestore.instance.collection(collection).doc(documentId);
  return documentRef.snapshots();
}
