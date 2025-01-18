import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';
import '../../../services/sms_service.dart';

class AttendanceAndPayment extends StatelessWidget {
  final List selectedStudents;
  final RxBool isStudentChoosen;
  final String groupName;

  final String groupId;

  AttendanceAndPayment(
      {required this.selectedStudents,
      required this.isStudentChoosen,
      required this.groupName,
      required this.groupId});

  SMSService _smsService = SMSService();
  RxBool messageLoader = false.obs;
  RxBool messageLoader2 = false.obs;
  RxBool messageLoader3 = false.obs;

  StudentController studentController = Get.put(StudentController());
  TextEditingController customMessage = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static RxBool isChoosen = false.obs;
  static GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      messageLoader.value = true;
                                      for (int i = 0;
                                          i < selectedStudents.length;
                                          i++) {
                                        if (checkStatus(
                                                selectedStudents[i]
                                                    ['studyDays'],
                                                studentController
                                                    .selectedStudyDate.value,
                                                groupId) ==
                                            'false') {
                                          if (await Permission.sms.isGranted &&
                                              selectedStudents[i]['phone']
                                                  .toString()
                                                  .isNotEmpty) {
                                            _smsService.sendSMS(
                                                selectedStudents[i]['phone'],
                                                "${box.read("attendance_text".replaceAll("\$ismi", "${selectedStudents[i]['name']}").replaceAll("\fam", "${selectedStudents[i]['surname']}"))}");
                                            Get.back();
                                          }
                                        } else {
                                          print('Sms yuborilmadi');
                                        }
                                        await Future.delayed(
                                            Duration(seconds: 1));
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
              child: Obx(() => CustomButton(
                    color: Colors.green,
                    text: messageLoader.value
                        ? "Yuborish ..."
                        : 'Davomat'.tr.capitalizeFirst!,
                  )),
            )),
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
                        child: Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            width: Get.width,
                            height: Get.height / 2.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      maxLines: 5,
                                      controller: customMessage,
                                      maxLength: 120,
                                      keyboardType: TextInputType.text,
                                      decoration: buildInputDecoratione(
                                          'Xabaringiz:(masalan) Hurmatli talabalar ob-havo yomonligi uchun darsimiz qoldiriladi'
                                                  .tr
                                                  .capitalizeFirst! ??
                                              ''),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    messageLoader3.value = true;
                                    if (customMessage.text.isNotEmpty) {
                                      for (int i = 0;
                                          i < selectedStudents.length;
                                          i++) {
                                        if (await Permission.sms.isGranted &&
                                            selectedStudents[i]['phone']
                                                .toString()
                                                .isNotEmpty) {
                                          _smsService.sendSMS(
                                              selectedStudents[i]['phone'],
                                              customMessage.text +
                                                  "\nHurmat bilan SmartEduTime");
                                        }

                                        await Future.delayed(
                                            Duration(seconds: 1));
                                      }
                                      messageLoader3.value = false;
                                      customMessage.clear();
                                      selectedStudents.clear();
                                      isStudentChoosen.value = false;

                                      Get.back();

                                      Get.snackbar(
                                        'Xabar', // Title
                                        "Xabaringiz yuborildi",

                                        // Message
                                        snackPosition: SnackPosition.BOTTOM,
                                        // Position of the snackbar
                                        backgroundColor: Colors.blue,
                                        colorText: Colors.white,
                                        borderRadius: 8,
                                        margin: EdgeInsets.all(10),
                                      );
                                    } else {
                                      Get.back();
                                    }
                                  },
                                  child: Obx(() => CustomButton(
                                      isLoading:
                                          studentController.isLoading.value,
                                      text: messageLoader3.value
                                          ? "Yuborilyapti. . ."
                                          : "Yuborish".tr.capitalizeFirst!)),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 4),
                child: CustomButton(
                  color: Colors.blue,
                  text: 'Shaxsiy',
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
