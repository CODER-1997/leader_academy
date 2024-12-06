import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../controllers/exams/exams_controller.dart';

class AddExams extends StatelessWidget {
  final String group;

  AddExams({required this.group});

  final _formKey = GlobalKey<FormState>();
  ExamsController examController = Get.put(ExamsController());

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.white,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                //this right here
                child: Form(
                  key: _formKey,
                  child: Obx(()=>Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    width: Get.width,
                    height:examController.isCefrExam.value ? Get.height/3 : Get.height / 2.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text("Imtihon yaratish"),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(() => GestureDetector(
                                  onTap: () {
                                    examController.isCefrExam.value =
                                    !examController.isCefrExam.value;
                                  },
                                  child: Container(
                                    width: 100,
                                    padding: EdgeInsets.all(4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: examController.isCefrExam.value
                                            ? Colors.green
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey, width: 1)),
                                    child: Text(
                                      'CEFR',
                                      style: TextStyle(
                                          color:
                                          examController.isCefrExam.value
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 16,),

                            TextFormField(
                                controller: examController.examName,
                                keyboardType: TextInputType.text,
                                decoration:
                                buildInputDecoratione('Imtihon nomi'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Maydonlar bo'sh bo'lmasligi kerak";
                                  }
                                  return null;
                                }),
                            examController.isCefrExam.value == false ?  SizedBox(
                              height: 16,
                            ):SizedBox(),
                            examController.isCefrExam.value == false ? TextFormField(
                                controller: examController.examQuestionCount,
                                keyboardType: TextInputType.number,
                                decoration:
                                buildInputDecoratione('Savollar soni'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Maydonlar bo'sh bo'lmasligi kerak";
                                  }
                                  return null;
                                }):SizedBox(),
                            examController.isCefrExam.value == false ?  SizedBox(
                              height: 16,
                            ):SizedBox(),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              examController.addNewExam(group);
                            }
                          },
                          child: Obx(() => CustomButton(
                              isLoading: examController.isLoading.value,
                              text: "Qo'shish")),
                        )
                      ],
                    ),
                  )),
                ),
              );
            },
          );
        });
  }
}
