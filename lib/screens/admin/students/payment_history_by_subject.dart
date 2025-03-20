import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:leader/controllers/students/student_controller.dart';
import 'package:leader/screens/admin/students/selected_subject_card2.dart';

import '../../../constants/form_field.dart';
import '../../../constants/input_formatter.dart';
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
  State<PaymentHistoryBySubject> createState() =>
      _PaymentHistoryBySubjectState();
}

StudentController studentController = Get.put(StudentController());

String paymentStatus(List payments, String date, String subject) {
  var result = "not";
  for (var item in payments) {
    if (item['subject'] == subject && item['paidDate'] == date) {
      result = item['paidSum'];
      break;
    }
  }

  return result;
}

String getId(List payments, String date, String subject) {
  var result = "";
  for (var item in payments) {
    if (item['subject'] == subject && item['paidDate'] == date) {
      result = item['id'];
      break;
    }
  }

  return result;
}

RxString isEdit = "".obs;

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
                    //  for (int i = 0; i < payments[0]['items']['payments'].where((el)=>el['subject'] ==widget.subject).length; i++)
                    for (var item in generateMonths())
                      Obx(
                        () => Container(
                          padding: EdgeInsets.all(6),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(item),
                                  ),
                                  isEdit.value == item
                                      ? SizedBox(
                                          width: Get.width / 4,
                                          child: TextFormField(
                                            buildCounter: (context,
                                                {required int currentLength,
                                                required bool isFocused,
                                                required int? maxLength}) {
                                              return null; // Hides the counter
                                            },
                                            decoration: InputDecoration(
                                              hintText: '',
                                            ),
                                            minLines: 1,
                                            maxLength: 8,
                                            onFieldSubmitted: (val) {
                                              studentController.editPayment(
                                                widget.id,
                                                getId(
                                                    payments[0]['items']
                                                        ['payments'],
                                                    item,
                                                    widget.subject),
                                                widget.subject.isEmpty
                                                    ? SelectedSubjectCard2
                                                        .selectedSubject.value
                                                    : widget.subject,
                                                val,
                                                item
                                              );

                                              isEdit.value = "";
                                            },
                                            inputFormatters: [
                                              ThousandSeparatorInputFormatter(),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              // Allow only numbers
                                              MaxValueInputFormatter(
                                                  int.parse('1000000')),
                                              // Custom formatter for max value
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        )
                                      : (paymentStatus(
                                                  payments[0]['items']
                                                      ['payments'],
                                                  item,
                                                  widget.subject) ==
                                              'not'
                                          ? SizedBox(
                                              width: Get.width / 4,
                                              child: TextFormField(
                                                buildCounter: (context,
                                                    {required int currentLength,
                                                    required bool isFocused,
                                                    required int? maxLength}) {
                                                  return null; // Hides the counter
                                                },
                                                decoration: InputDecoration(
                                                  hintText: '',
                                                ),
                                                minLines: 1,
                                                maxLength: 8,
                                                onFieldSubmitted: (val) {
                                                  studentController.addPayment(
                                                      widget.id,
                                                      item,
                                                      widget.subject.isEmpty
                                                          ? SelectedSubjectCard2
                                                              .selectedSubject
                                                              .value
                                                          : widget.subject,
                                                      val);
                                                  isEdit.value = "";
                                                },
                                                inputFormatters: [
                                                  ThousandSeparatorInputFormatter(),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  // Allow only numbers
                                                  MaxValueInputFormatter(
                                                      int.parse('1000000')),
                                                  // Custom formatter for max value
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "${paymentStatus(payments[0]['items']['payments'], item, widget.subject)}"),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      isEdit.value = item;
                                                    },
                                                    child: Icon(Icons.edit),
                                                  )
                                                ],
                                              ),
                                            ))
                                ],
                              ),
                              Container(
                                width: Get.width,
                                height: .2,
                                color: Colors.grey,
                              )
                            ],
                          ),
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
    );
  }
}
