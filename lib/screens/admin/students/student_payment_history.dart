import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/input_formatter.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';

class AdminStudentPaymentHistory extends StatefulWidget {
  final String uniqueId;
  final String id;
  final String name;
  final String surname;
  final List paidMonths;
  final String yeralyFee;
  final String paymentType;

  AdminStudentPaymentHistory({
    required this.uniqueId,
    required this.id,
    required this.name,
    required this.surname,
    required this.paidMonths,
    required this.yeralyFee,
    required this.paymentType,
  });

  @override
  State<AdminStudentPaymentHistory> createState() =>
      _AdminStudentPaymentHistoryState();
}

class _AdminStudentPaymentHistoryState extends State<AdminStudentPaymentHistory>
    with SingleTickerProviderStateMixin {
  StudentController studentController = Get.put(StudentController());

  final _formKey = GlobalKey<FormState>();

  late TabController _tabController;

  int calculateTotalFee(List payments) {
    int total = 0;

    for (int j = 0; j < payments.length; j++) {
      if (payments[j]['courseFee']) {
        total += int.parse(payments[j]['paidSum']);
      }
    }

    return total;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> months = getFormattedMonthsOfCurrentYear();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CupertinoColors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          '${widget.name}'.capitalizeFirst! +
              " " +
              "${widget.surname}".capitalizeFirst! +
              "  payment history",
          style:
              appBarStyle.copyWith(color: CupertinoColors.black, fontSize: 12),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LeaderStudents')
                .where('items.uniqueId', isEqualTo: '${widget.uniqueId}')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: Get.height,
                    width: Get.width,
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                List payments = snapshot.data!.docs;
                return payments[0]['items']['payments'].isNotEmpty
                    ? Column(
                        children: [
                          int.parse(widget.yeralyFee.removeAllWhitespace) != 0?
                          ( int.parse(widget.yeralyFee.removeAllWhitespace) -
                                      calculateTotalFee(
                                          payments[0]['items']['payments']) ==
                                  0
                              ? CustomButton(text: "Yillik 100% to'langan") : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      children: [
                                        widget.paymentType == 'yearly'
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Yillik to'lov miqdori: ${widget.yeralyFee} so'm",
                                                    style: appBarStyle.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "To'lanishi kerak: ${int.parse(widget.yeralyFee.removeAllWhitespace) - calculateTotalFee(payments[0]['items']['payments'])} so'm",
                                                    style: appBarStyle.copyWith(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                )):SizedBox()

                              ,
                          for (int i = 0;
                              i < payments[0]['items']['payments'].length;
                              i++)
                            Container(
                              width: Get.width,
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: CupertinoColors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: Colors.black, width: .5)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To'lov qilingan sana: ",
                                            style: appBarStyle.copyWith(
                                                fontSize: 10,
                                                color:
                                                    CupertinoColors.systemGrey),
                                          ),
                                          Text(
                                            convertDate(
                                                "${payments[0]['items']['payments'][i]['paidDate']}"),
                                            style: appBarStyle.copyWith(
                                                color: Colors.blue,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To'lov miqdori: ",
                                            style: appBarStyle.copyWith(
                                                fontSize: 10),
                                          ),
                                          Text(
                                            " ${payments[0]['items']['payments'][i]['paidSum']} so'm",
                                            style: appBarStyle.copyWith(
                                                color: Colors.green,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        insetPadding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 16),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                        //this right here
                                                        child: Form(
                                                          key: _formKey,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                            width: Get.width,
                                                            height: Get.height /
                                                                2.5,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    "Edit course fee"),
                                                                TextFormField(
                                                                    inputFormatters: [
                                                                      ThousandSeparatorInputFormatter(),
                                                                    ],
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    controller:
                                                                        studentController
                                                                            .payment,
                                                                    decoration:
                                                                        buildInputDecoratione(
                                                                            'Price'),
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                      }
                                                                      return null;
                                                                    }),
                                                                TextFormField(
                                                                  inputFormatters: [
                                                                    ThousandSeparatorInputFormatter(),
                                                                  ],
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  controller:
                                                                      studentController
                                                                          .paymentComment,
                                                                  decoration:
                                                                      buildInputDecoratione(
                                                                          'Comment'),
                                                                  // validator:
                                                                  //     (value) {
                                                                  //   if (value!
                                                                  //       .isEmpty) {
                                                                  //     return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                  //   }
                                                                  //   return null;
                                                                  // },
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Obx(
                                                                      () => Text(
                                                                          'Paid date:  ${studentController.paidDate.value}'),
                                                                    ),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          studentController
                                                                              .showDate(studentController.paidDate);
                                                                        },
                                                                        icon: Icon(
                                                                            Icons.calendar_month))
                                                                  ],
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (_formKey
                                                                            .currentState!
                                                                            .validate() &&
                                                                        studentController
                                                                            .paidDate
                                                                            .value
                                                                            .isNotEmpty) {
                                                                      print(widget
                                                                          .id);
                                                                      print(payments[0]['items']['payments']
                                                                              [
                                                                              i]
                                                                          [
                                                                          'id']);
                                                                      studentController.editPayment(
                                                                          widget
                                                                              .id,
                                                                          payments[0]['items']['payments'][i]
                                                                              [
                                                                              'id']);
                                                                    }
                                                                  },
                                                                  child: Obx(() => CustomButton(
                                                                      isLoading: studentController
                                                                          .isLoading
                                                                          .value,
                                                                      text: 'Edit'
                                                                          .tr
                                                                          .capitalizeFirst!)),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: Colors.purple,
                                                )),
                                            IconButton(
                                                onPressed: () {
                                                  studentController
                                                      .deletePayment(
                                                          widget.id,
                                                          payments[0]['items']
                                                                  ['payments']
                                                              [i]['id']);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.redAccent,
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  payments[0]['items']['payments'][i]
                                              ['courseFee'] ==
                                          false
                                      ? Text(
                                          "Yotoqxona va boshqa xizmatlarga",
                                          style: appBarStyle.copyWith(
                                              fontSize: 10),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            )
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                            ),
                            Image.asset(
                              'assets/fee_not_charged.png',
                              width: 222,
                            ),
                            Text(
                              '${widget.name}'.capitalizeFirst! +
                                  " " +
                                  "${widget.surname}".capitalizeFirst! +
                                  " has not any payments ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.white38,
                insetPadding: EdgeInsets.symmetric(horizontal: 16),
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
                    height: Get.height / 1.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text("Kurs to'lovi"),
                            IconButton(
                                onPressed: Get.back, icon: Icon(Icons.close))
                          ],
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              ThousandSeparatorInputFormatter(),
                            ],
                            controller: studentController.payment,
                            decoration: buildInputDecoratione('Price'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Maydonlar bo'sh bo'lmasligi kerak";
                              }
                              return null;
                            }),
                        TextFormField(
                          keyboardType: TextInputType.text,

                          controller: studentController.paymentComment,
                          decoration: buildInputDecoratione("To'lov kodi"),
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Maydonlar bo'sh bo'lmasligi kerak";
                          //   }
                          //   return null;
                          // },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() => InkWell(
                                  onTap: () {
                                    studentController.courseFee.value = true;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: studentController.courseFee.value
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(112),
                                        border: Border.all(
                                            color: Colors.green, width: 1)),
                                    child: Text(
                                      "Kursga",
                                      style: TextStyle(
                                        color: studentController.courseFee.value
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                            Obx(() => InkWell(
                                  onTap: () {
                                    studentController.courseFee.value = false;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 8),
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color:
                                            studentController.courseFee.value ==
                                                    false
                                                ? Colors.green
                                                : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(112),
                                        border: Border.all(
                                            color: Colors.green, width: 1)),
                                    child: Text(
                                      "Boshqa (Yotoqxona ,..)",
                                      style: TextStyle(
                                        color:
                                            studentController.courseFee.value ==
                                                    false
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Text(
                                  'Paid date:  ${studentController.paidDate.value}'),
                            ),
                            IconButton(
                                onPressed: () {
                                  studentController
                                      .showDate(studentController.paidDate);
                                },
                                icon: Icon(Icons.calendar_month))
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate() &&
                                studentController.paidDate.value.isNotEmpty) {
                              studentController.addPayment(
                                  widget.id, studentController.paidDate.value);
                            }
                          },
                          child: Obx(() => CustomButton(
                              isLoading: studentController.isLoading.value,
                              text: 'confirm'.tr.capitalizeFirst!)),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
