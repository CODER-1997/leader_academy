import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:leader/constants/text_styles.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../controllers/students/student_controller.dart';

class AddStudent extends StatelessWidget {
  final String groupName;
  final String groupId;

  AddStudent({
    required this.groupName,
    required this.groupId,
  });

  StudentController studentController = Get.put(StudentController());
  final _formKey = GlobalKey<FormState>();

  Rx isNewStudent = true.obs;
  RxString studentId = ''.obs;
  RxList studentGroups = [].obs;

  bool checkAbsense() {
    var isInGroups = false;
    for (var item in studentController.students.value) {
      print(item['name']);
      print(item['surname']);
      print(studentController.name.text);
      print(studentController.surname.text);
      if (item['name'].toString().toLowerCase() ==
              studentController.name.text.toLowerCase() &&
          item['surname'].toString().toLowerCase() ==
              studentController.surname.text.toLowerCase()) {
        isInGroups = true;
        print('bor ekan');
        studentId.value = item['id'];
        break;
      }
    }

    return isInGroups;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        CupertinoIcons.person_add_solid,
        color: Colors.white,
      ),
      onPressed: () {
        studentController.selectedGroup.value = groupName;
        studentController.selectedGroupId.value = groupId;
        studentController.isFreeOfCharge.value = false;
        studentController.fetchStudents();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(0),
              //this right here
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    width: Get.width,
                    height: Get.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Column(
                            children: [
                              Text(
                                "Talaba qo'shish",
                                style: appBarStyle,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                  controller: studentController.name,
                                  keyboardType: TextInputType.text,
                                  decoration: buildInputDecoratione(
                                      'Ismi:'.tr.capitalizeFirst! ?? ''),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Maydonlar bo'sh bo'lmasligi kerak";
                                    }
                                    return null;
                                  }),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                  controller: studentController.surname,
                                  keyboardType: TextInputType.text,
                                  decoration: buildInputDecoratione(
                                      'Familiyasi'.tr.capitalizeFirst! ?? ''),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Maydonlar bo'sh bo'lmasligi kerak";
                                    }
                                    return null;
                                  }),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                controller: studentController.phone,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                      mask: '+998 ## ### ## ##',
                                      filter: {"#": RegExp(r'[0-9]')},
                                      type: MaskAutoCompletionType.lazy)
                                ],
                                decoration: buildInputDecoratione(
                                    '+998 ## ### ## ##'.tr.capitalizeFirst! ??
                                        ''),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Maydonlar bo'sh bo'lmasligi kerak";
                                  }
                                  return null;
                                },
                              ),

                              studentController.monthly.value == false
                                  ? SizedBox(
                                      height: 16,
                                    )
                                  : SizedBox(),
                              studentController.monthly.value == false
                                  ? TextFormField(
                                      controller: studentController.yearlyFee,
                                      keyboardType: TextInputType.number,
                                      decoration: buildInputDecoratione(
                                          "Yillik to'lovni kiriting"
                                                  .tr
                                                  .capitalizeFirst! ??
                                              ''),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Maydonlar bo'sh bo'lmasligi kerak";
                                        }
                                        return null;
                                      },
                                    )
                                  : SizedBox(),
                              Row(
                                children: [
                                  Obx(
                                    () => Text(
                                        'Kelgan kuni:  ${studentController.paidDate.value}'),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        studentController.showDate(
                                            studentController.paidDate);
                                      },
                                      icon: Icon(Icons.calendar_month))
                                ],
                              ),

                              // SizedBox(
                              //   height: 16,
                              // ),
                              // Row(
                              //   mainAxisAlignment:
                              //   MainAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       'Choose Group',
                              //       style: appBarStyle,
                              //     ),
                              //   ],
                              // ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() => InkWell(
                                        onTap: () {
                                          studentController
                                                  .isFreeOfCharge.value =
                                              !studentController
                                                  .isFreeOfCharge.value;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 8),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: studentController
                                                      .isFreeOfCharge.value
                                                  ? Colors.green
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(112),
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1)),
                                          child: Text(
                                            "To'lovdan ozod",
                                            style: TextStyle(
                                              color: studentController
                                                      .isFreeOfCharge.value
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() => InkWell(
                                        onTap: () {
                                          studentController.paymentType.value =
                                              "monthly";
                                          studentController.monthly.value =
                                              true;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 8),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: studentController
                                                          .paymentType.value ==
                                                      "monthly"
                                                  ? Colors.green
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(112),
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1)),
                                          child: Text(
                                            "Oylik",
                                            style: TextStyle(
                                              color: studentController
                                                          .paymentType.value ==
                                                      "monthly"
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Obx(() => InkWell(
                                        onTap: () {
                                          studentController.paymentType.value =
                                              "yearly";
                                          studentController.monthly.value =
                                              false;
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 8),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: studentController
                                                          .paymentType.value ==
                                                      "yearly"
                                                  ? Colors.green
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(112),
                                              border: Border.all(
                                                  color: Colors.green,
                                                  width: 1)),
                                          child: Text(
                                            "Yillik",
                                            style: TextStyle(
                                              color: studentController
                                                          .paymentType.value ==
                                                      "yearly"
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Obx(() => Column(
                              children: [
                                isNewStudent.value == false
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.warning_outlined,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text("Shu ismli o'quvchi topildi"),
                                        ],
                                      )
                                    : SizedBox(),
                                isNewStudent.value == false
                                    ? Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: InkWell(
                                          onTap: () {
                                            studentController.attachGroup(
                                                studentId.value, groupId);
                                          },
                                          child: CustomButton(
                                              text: "Mavjud talaba sifatida"),
                                        ))
                                    : SizedBox(),
                                isNewStudent.value == false
                                    ? InkWell(
                                  onTap: (){
                                    if (_formKey.currentState!.validate() &&
                                        studentController
                                            .selectedGroupId.value.isNotEmpty) {
                                      studentController.addNewStudent( [groupId] );
                                    }
                                  },
                                      child: Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: CustomButton(
                                              text: "Yangi talaba sifatida"),
                                        ),
                                    )
                                    : SizedBox(),
                                isNewStudent.value
                                    ? InkWell(
                                        onTap: () {

                                          if (checkAbsense()) {
                                            isNewStudent.value = false;
                                          }
                                          else{
                                            studentController.addNewStudent( [groupId] );

                                          }
                                        },
                                        child: Obx(() => CustomButton(
                                            isLoading: studentController
                                                .isLoading.value,
                                            text: "Qo'shish"
                                                .tr
                                                .capitalizeFirst!)),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 16,
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    isNewStudent.value = true;
                                  },
                                  child: CustomButton(
                                      color: Colors.red,
                                      text: "Bekor qilish".tr.capitalizeFirst!),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
