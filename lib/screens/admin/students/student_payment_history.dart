import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:leader/screens/admin/students/payment_history_by_subject.dart';
import 'package:leader/screens/admin/students/selected_subject_card2.dart';

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
  final String subject;
  final String? date;

  AdminStudentPaymentHistory({
    required this.uniqueId,
    required this.id,
    required this.name,
    required this.surname,
    required this.paidMonths,
    required this.yeralyFee,
    required this.paymentType,
    required this.subject,
    this.date,
  });

  @override
  State<AdminStudentPaymentHistory> createState() =>
      _AdminStudentPaymentHistoryState();
}

class _AdminStudentPaymentHistoryState extends State<AdminStudentPaymentHistory>
    with SingleTickerProviderStateMixin {
  StudentController studentController = Get.put(StudentController());


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

  int getUniqueCode(List students) {
    int code = 0;
    for (var student in students) {
      code += int.parse((student['items']['payments'].length).toString());
    }
    return code + 1;
  }

  TextEditingController paymentCode(List students) {
    return TextEditingController(text: getUniqueCode(students).toString());
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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

        bottom: TabBar(
           padding: EdgeInsets.zero,
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: [
            Container(
                alignment: Alignment.center,
                width: Get.width / 2,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Matem',
                  style: TextStyle(color: Colors.white,fontSize: 10),
                )),
            Text(
              'Ona tili',
              style: TextStyle(color: Colors.white,fontSize: 10),
            ),
            Container(
                alignment: Alignment.center,
                width: Get.width / 2,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Fizika',
                  style: TextStyle(color: Colors.white,fontSize: 10),
                )),
            Container(
                alignment: Alignment.center,
                width: Get.width / 2,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Ingliz tili',
                  style: TextStyle(color: Colors.white,fontSize: 8),
                )),
            Container(
                alignment: Alignment.center,
                width: Get.width / 2,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Rus tili',
                  style: TextStyle(color: Colors.white,fontSize: 10),
                )), Container(
                alignment: Alignment.center,
                width: Get.width / 2,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Tarix',
                  style: TextStyle(color: Colors.white,fontSize: 10),
                )),
          ],
        ),
        backgroundColor: Colors.black,
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
              "  To'lovlar tarixi",
          style:
              appBarStyle.copyWith(color: CupertinoColors.white, fontSize: 12),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
          children: [
            PaymentHistoryBySubject(
                uniqueId: widget.uniqueId,
                id: widget.id,
                paidMonths: widget.paidMonths, paymentType: widget.paymentType, subject: 'Matematika'),
            PaymentHistoryBySubject(
                uniqueId: widget.uniqueId,
                id: widget.id,
                paidMonths: widget.paidMonths, paymentType: widget.paymentType, subject: 'Ona tili'),
            PaymentHistoryBySubject(
                uniqueId: widget.uniqueId,
                id: widget.id,
                paidMonths: widget.paidMonths, paymentType: widget.paymentType, subject: 'Fizika'),
            PaymentHistoryBySubject(
                uniqueId: widget.uniqueId,
                id: widget.id,
                paidMonths: widget.paidMonths, paymentType: widget.paymentType, subject: 'Ingliz tili'),
            PaymentHistoryBySubject(
                uniqueId: widget.uniqueId,
                id: widget.id,
                paidMonths: widget.paidMonths, paymentType: widget.paymentType, subject: 'Rus tili'),
            PaymentHistoryBySubject(
                uniqueId: widget.uniqueId,
                id: widget.id,
                paidMonths: widget.paidMonths, paymentType: widget.paymentType, subject: 'Tarix')
          ]),


    );
  }
}
