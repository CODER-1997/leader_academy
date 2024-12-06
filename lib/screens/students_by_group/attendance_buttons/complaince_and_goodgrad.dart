import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';
import '../../../services/sms_service.dart';

class ComplainceAndGoodgrad extends StatelessWidget {
  final List selectedStudents;
  final RxBool isStudentChoosen;
  final String groupName;

  final String groupId;

  ComplainceAndGoodgrad(
      {required this.selectedStudents, required this.isStudentChoosen, required this.groupName, required this.groupId});

  SMSService _smsService = SMSService();
  RxBool messageLoader = false.obs;
  RxBool messageLoader2 = false.obs;
  RxBool messageLoader3 = false.obs;

  StudentController studentController = Get.put(StudentController());
  TextEditingController customMessage = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 66,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                child: InkWell(
                  onTap: () async {
                    if (selectedStudents.isEmpty) {
                      Get.snackbar(
                        'Xatolik', // Title
                        'Talabalar tanlanmagan', // Message
                        snackPosition: SnackPosition.TOP,
                        // Position of the snackbar
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        borderRadius: 8,
                        margin: EdgeInsets.all(10),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            insetPadding: EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            //this right here
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              width: Get.width,
                              height: 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        'Rostdanham yuborasizmi ?',
                                        style: appBarStyle.copyWith(),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          messageLoader.value = true;
                                          for (int i = 0;
                                          i < selectedStudents.length;
                                          i++) {
                                            if (await Permission.sms
                                                .isGranted &&
                                                selectedStudents[i]['phone']
                                                    .toString()
                                                    .isNotEmpty) {
                                              _smsService.sendSMS(
                                                  selectedStudents[i]['phone'],
                                                  "Assalomu Aleykum ,"
                                                      "\nFarzandingiz ${selectedStudents[i]['surname']
                                                      .toString()
                                                      .capitalizeFirst}  ${selectedStudents[i]['name']
                                                      .toString()
                                                      .capitalizeFirst!}ning o'zlashtirishi yaxshi emas");
                                      
                                            }
                                          }

                                          messageLoader.value = false;
                                          selectedStudents.clear();
                                          isStudentChoosen.value = false;

                                          Get.snackbar(
                                            'Xabar', // Title
                                            'Xabaringiz yuborildi',
                                            // Message
                                            snackPosition: SnackPosition.BOTTOM,
                                            // Position of the snackbar
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            borderRadius: 8,
                                            margin: EdgeInsets.all(10),
                                          );
                                        },
                                        child: Text(
                                          'Tasdiqlash'.tr.capitalizeFirst!,
                                          style: appBarStyle.copyWith(
                                              color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: Get.back,
                                          child: Text(
                                            'Bekor',
                                            style: appBarStyle.copyWith(
                                                color: Colors.red),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Obx(() =>
                      CustomButton(
                        color: Colors.red,
                        text: messageLoader.value
                            ? "Yuborish ..."
                            : 'Shikoyat'.tr.capitalizeFirst!,
                      )),
                )),
            SizedBox(width: 4,),
            Expanded(
                child: InkWell(
                  onTap: () async {
                    if (selectedStudents.isEmpty) {
                      Get.snackbar(
                        'Xatolik', // Title
                        'Talabalar tanlanmagan', // Message
                        snackPosition: SnackPosition.TOP,
                        // Position of the snackbar
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        borderRadius: 8,
                        margin: EdgeInsets.all(10),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            insetPadding: EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            //this right here
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              width: Get.width,
                              height: 180,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        'Rostdanham yuborasizmi ?',
                                        style: appBarStyle.copyWith(),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          messageLoader.value = true;
                                          for (int i = 0;
                                          i < selectedStudents.length;
                                          i++) {
                                            if (await Permission.sms
                                                .isGranted &&
                                                selectedStudents[i]['phone']
                                                    .toString()
                                                    .isNotEmpty) {
                                              _smsService.sendSMS(
                                                  selectedStudents[i]['phone'],
                                                  "Assalomu Aleykum ,"
                                                      "\nFarzandingiz ${selectedStudents[i]['surname']
                                                      .toString()
                                                      .capitalizeFirst}  ${selectedStudents[i]['name']
                                                      .toString()
                                                      .capitalizeFirst!}ning o'zlashtirishi yaxshi");

                                            }
                                          }

                                          messageLoader.value = false;
                                          selectedStudents.clear();
                                          isStudentChoosen.value = false;

                                          Get.snackbar(
                                            'Xabar', // Title
                                            'Xabaringiz yuborildi',
                                            // Message
                                            snackPosition: SnackPosition.BOTTOM,
                                            // Position of the snackbar
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            borderRadius: 8,
                                            margin: EdgeInsets.all(10),
                                          );
                                        },
                                        child: Text(
                                          'Tasdiqlash'.tr.capitalizeFirst!,
                                          style: appBarStyle.copyWith(
                                              color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: Get.back,
                                          child: Text(
                                            'Bekor',
                                            style: appBarStyle.copyWith(
                                                color: Colors.red),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: Obx(() =>
                      CustomButton(
                        color: Colors.green,
                        text: messageLoader.value
                            ? "Yuborish ..."
                            : "Rag'bat".tr.capitalizeFirst!,
                      )),
                )),

          ],
        ),
      ),
    ) ;
    }
}
