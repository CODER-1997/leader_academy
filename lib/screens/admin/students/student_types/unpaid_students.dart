import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
 import 'package:leader/constants/custom_widgets/student_card.dart';
import 'package:leader/screens/admin/students/student_info.dart';

import '../../../../constants/custom_widgets/emptiness.dart';
 import '../../../../constants/theme.dart';
 import '../../../../services/sms_service.dart';

class UnPaidStudents extends StatelessWidget {
  final List students;
  final String ? title;

  UnPaidStudents({required this.students, this.title});

  RxBool messageLoader = false.obs;
  SMSService _smsService = SMSService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        title: Text(
         title ?? "Unpaid Students",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: dashBoardColor,
        toolbarHeight: 64,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 4),
            Expanded(
              child: students.length != 0
                  ? ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(StudentInfo(studentId: students[i].id));
                          },
                          child: StudentCard(
                            item: students[i]['items'],
                          ),
                        );
                      })
                  : Emptiness(
                      title: 'Our center has not any free of charged student '),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: InkWell(
      //   onTap: () async {
      //     final snackBar = SnackBar(
      //       content: Text('Your message has been sent!'),
      //       backgroundColor: Colors.green,
      //     );
      //     messageLoader.value = true;
      //
      //     for (var student in students) {
      //
      //       if (await Permission.sms.isGranted && student['items']['phone'].toString().isNotEmpty) {
      //         String phone = student['items']['phone'].toString().replaceAll(' ', '');
      //         if (!phone.startsWith('+998') && phone.length == 9) {
      //           phone = '+998$phone';
      //         }
      //         else if(phone.startsWith('998') && phone.length == 12) {
      //           phone = '+$phone';
      //
      //
      //         }
      //         String surname = student['items']['surname'].toString().capitalizeFirst!;
      //         String name = student['items']['name'].toString().capitalizeFirst!;
      //
      //         _smsService.sendSMS(
      //             phone,
      //                   "Assalomu Alykum"
      //                 "\nFarzandingiz $surname $name kurs to'lovini oyning oxirigacha qilmasalar guruhdan chetlashtiriladi"
      //                 "\nOzod Asadov: +998 91 649 00 94"
      //         );
      //         await Future.delayed(Duration(milliseconds: 1000));
      //
      //
      //       }
      //     }
      //
      //
      //
      //
      //     messageLoader.value = false;
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Obx(() => CustomButton(
      //           color: Colors.red,
      //           isLoading: messageLoader.value,
      //           text: 'Send sms to parents',
      //         )),
      //   ),
      // ),
    );
  }
}
