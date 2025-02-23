import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:leader/screens/admin/students/selected_subject_card2.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/input_formatter.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/utils.dart';

class PaymentHistoryBySubject extends StatefulWidget {

  final String uniqueId;
  final String id;

  final List paidMonths;
   final String paymentType;
  final String subject;
  final String? date;

  PaymentHistoryBySubject({
    required this.uniqueId,
    required this.id,

    required this.paidMonths,
     required this.paymentType,
    required this.subject,
    this.date,
  });

  @override
  State<PaymentHistoryBySubject> createState() => _PaymentHistoryBySubjectState();
}
final _formKey = GlobalKey<FormState>();

class _PaymentHistoryBySubjectState extends State<PaymentHistoryBySubject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return Column(
                children: [

                  for (int i = 0; i < payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).length; i++)

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
                                      "# ${payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).toList()[i]['paymentCode']}"),
                                  Text(
                                    "To'lov qilingan sana: ",
                                    style: appBarStyle.copyWith(
                                        fontSize: 10,
                                        color:
                                        CupertinoColors.systemGrey),
                                  ),
                                  Text(
                                    convertDate(
                                        "${payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).toList()[i]['paidDate']}"),
                                    style: appBarStyle.copyWith(
                                        color: Colors.blue,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    "${payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).toList()[i]['subject']}",
                                    style: TextStyle(
                                        color: Colors.red,
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
                                    " ${payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).toList()[i]['paidSum']} so'm",
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
                                          studentController  .setPaymentCode(payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).toList()  [i]['paymentCode']   .toString()  .removeAllWhitespace);
                                          studentController.paidDate.value = payments[0]['items']['payments'] .where((el)=>el['subject'] ==widget.subject).toList()[i]['paidDate'];
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
                                                            "Tahrirlash"),
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
                                                                "To'lov miqdori"),
                                                            validator:
                                                                (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Maydonlar bo'sh bo'lmasligi kerak";
                                                              }
                                                              return null;
                                                            }),
                                                        TextFormField(
                                                          keyboardType:
                                                          TextInputType
                                                              .number,
                                                          controller:
                                                          studentController
                                                              .paymentComment,
                                                          decoration:
                                                          buildInputDecoratione(
                                                              "To'lov kodi"),
                                                          validator:
                                                              (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return "Maydonlar bo'sh bo'lmasligi kerak";
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                        Row(
                                                          children: [
                                                            Obx(
                                                                  () => Text(
                                                                  'To\'lov sanasi:  ${studentController.paidDate.value}'),
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
                                     if (_formKey .currentState!  .validate() &&  studentController
                                                                    .paidDate
                                                                    .value
                                                                    .isNotEmpty) {

                               studentController.editPayment(  widget .id,
                                                                  payments[0]['items']['payments'] .where((el)=>el['subject'] ==widget.subject).toList() [i]
                                                                  [
                                                                  'id'],
                                                                  payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).toList()[i]
                                                                  [
                                                                  'subject']);
                                                            }
                                                          },
                                                          child: Obx(() => CustomButton(
                                                              isLoading: studentController
                                                                  .isLoading
                                                                  .value,
                                                              text: 'Tahrirlash'
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
                                                child: Container(
                                                  padding:
                                                  EdgeInsets.all(
                                                      16),
                                                  decoration: BoxDecoration(
                                                      color:
                                                      Colors.white,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12)),
                                                  width: Get.width,
                                                  height: 220,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                          Text(
                                                            'Rostdanham to\'lov o\'chirilsinmi ?',
                                                            style: appBarStyle
                                                                .copyWith(),
                                                            textAlign:
                                                            TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                        children: [
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              studentController.deletePayment(
                                                                  widget
                                                                      .id,
                                                                  payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).toList()
                                                             [i]     [
                                                                  'id']);
                                                            },
                                                            child: Text(
                                                              "O'chirish"
                                                                  .tr
                                                                  .capitalizeFirst!,
                                                              style: appBarStyle.copyWith(
                                                                  color:
                                                                  Colors.red),
                                                            ),
                                                          ),
                                                          TextButton(
                                                              onPressed: Get
                                                                  .back,
                                                              child:
                                                              Text(
                                                                'Bekor',
                                                                style: appBarStyle.copyWith(
                                                                    color:
                                                                    Colors.green),
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
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
          SelectedSubjectCard2.selectedSubject.value = widget.subject;
          studentController.paidDate.value = "";
          studentController.payment.clear();
          studentController.paymentComment.clear();
          if (widget.date != null) {
            studentController.paidDate.value = DateFormat('dd-MM-yyyy')
                .format(DateFormat("MMMM, yyyy").parse(widget.date.toString()));
          }
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
                    height: Get.height / 1.4,
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
                            decoration: buildInputDecoratione("To'lov miqdori"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Maydonlar bo'sh bo'lmasligi kerak";
                              }
                              return null;
                            }),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: studentController.paymentComment,
                          decoration: buildInputDecoratione("To'lov kodi"),
                        ),
                        // StreamBuilder(
                        //     stream: FirebaseFirestore.instance
                        //         .collection('LeaderStudents')
                        //         .snapshots(),
                        //     builder: (context,
                        //         AsyncSnapshot<QuerySnapshot> snapshot) {
                        //       if (snapshot.connectionState ==
                        //           ConnectionState.waiting) {
                        //         return Text("Kod yaratyapmiz");
                        //       }
                        //       if (snapshot.hasError) {
                        //         return Center(
                        //             child: Text('Error: ${snapshot.error}'));
                        //       }
                        //       if (snapshot.hasData) {
                        //         List students = snapshot.data!.docs;
                        //         studentController.setCode(
                        //             getUniqueCode(students).toString());
                        //         return TextFormField(
                        //           keyboardType: TextInputType.number,
                        //           controller: studentController.paymentComment,
                        //           decoration:
                        //               buildInputDecoratione("To'lov kodi"),
                        //         );
                        //       }
                        //       // If no data available
                        //
                        //       else {
                        //         return Text('No data'); // No data available
                        //       }
                        //     }),
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
                        Obx(
                              () => Row(
                            children: [
                              studentController.paidDate.value.isNotEmpty
                                  ? IconButton(
                                  onPressed: () {
                                    changeDateByOneDay(studentController.paidDate,increase: false);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.minus_circle,
                                    size: 33,
                                  ))
                                  : SizedBox(),
                              Obx(
                                    () => Text(
                                    'Sana:  ${studentController.paidDate.value}'),
                              ),
                              IconButton(
                                  onPressed: () {
                                    studentController
                                        .showDate(studentController.paidDate);
                                  },
                                  icon: Icon(Icons.calendar_month)),
                              studentController.paidDate.value.isNotEmpty
                                  ? IconButton(
                                  onPressed: () {
                                    changeDateByOneDay(studentController.paidDate,increase: true);

                                  },
                                  icon: Icon(
                                    CupertinoIcons.plus_circle,
                                    size: 33,
                                  ))
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (var item in generateMonths())
                                  InkWell(
                                    onTap: () {
                                      studentController.paidDate.value = item;
                                    },
                                    child: Obx(() => Container(
                                      padding: EdgeInsets.all(8),
                                      margin: EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1),
                                          color: studentController
                                              .paidDate.value ==
                                              item
                                              ? Colors.green
                                              : Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(12)),
                                      child: Text(
                                        convertDateToMonthYear(item),
                                        style: TextStyle(
                                          color: studentController
                                              .paidDate.value ==
                                              item
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    )),
                                  )
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectedSubjectCard2(subject: "Matematika"),
                              SelectedSubjectCard2(subject: "Fizika"),
                              SelectedSubjectCard2(subject: "Rus tili"),
                              SelectedSubjectCard2(subject: "Ona tili"),
                              SelectedSubjectCard2(subject: "Tarix"),
                              SelectedSubjectCard2(subject: "Ingliz tili"),
                            ],
                          ),
                        ),
                        Obx(() => SelectedSubjectCard2
                            .selectedSubject.value.isEmpty &&
                            widget.subject.isEmpty
                            ? InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text('Bazi maydonlar tanlanmagan'
                                  .tr
                                  .capitalizeFirst!),
                              backgroundColor: Colors.red,
                              dismissDirection:
                              DismissDirection.startToEnd,
                            ));
                          },
                          child: CustomButton(
                              isLoading: false,
                              color: Colors.grey,
                              text: 'Tasdiqlash'.tr.capitalizeFirst!),
                        )
                            : InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate() &&
                                studentController
                                    .paidDate.value.isNotEmpty) {
                              studentController.addPayment(
                                  widget.id,
                                  studentController.paidDate.value,
                                  widget.subject.isEmpty
                                      ? SelectedSubjectCard2
                                      .selectedSubject.value
                                      : widget.subject);
                            }
                          },
                          child: Obx(() => CustomButton(
                              isLoading:
                              studentController.isLoading.value,
                              text: 'Tasdiqlash'.tr.capitalizeFirst!)),
                        ))
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),);
  }
}
