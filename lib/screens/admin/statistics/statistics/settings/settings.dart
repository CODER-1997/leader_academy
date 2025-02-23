import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/constants/theme.dart';

import '../../../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../../../constants/custom_widgets/gradient_button.dart';
import '../../../../../constants/text_styles.dart';
import 'allowed_devices.dart';

class LeaderSettings extends StatefulWidget {
  @override
  State<LeaderSettings> createState() => _LeaderSettingsState();
}

class _LeaderSettingsState extends State<LeaderSettings> {
  final _formKey = GlobalKey<FormState>();

  GetStorage box = GetStorage();

  TextEditingController attendanceController = TextEditingController();
  TextEditingController ecamResults = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sozlamalar"),
      ),
      backgroundColor: homePagebg,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MessageCreater(
              title: 'Davomat xabari',
              keyOnBox: "attendance_text",
              text:
              "Farzandingiz #ismi #fam  #fan #guruh darsiga kelmadi . #sana",
            ),
            SizedBox(
              height: 8,
            ),
            MessageCreater(
              title: 'Imtihon xabari',
              keyOnBox: "exam_text",
              text:
              "Farzandingiz #ismi #fam #fan #guruh imtihonidan #foiz oldi . #sana",
            ),
            SizedBox(
              height: 8,
            ),
           box.read('isLogged')=="004422" ? GestureDetector(
                onTap: () {
                  Get.to(AllowedDevicesScreen()
                  );
                },
                child: Item(title: 'Qurulmalar')):SizedBox()
          ],
        ),
      ),
    );
  }
}

// HelperWidget
class Item extends StatelessWidget {
  final String title;

  Item({
    required this.title,
  });

  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(title),
          trailing: IconButton(
              onPressed: () {}, icon: Icon(Icons.arrow_forward_ios_rounded)),
        ));
  }
}

class MessageCreater extends StatelessWidget {
  final String title;
  final String keyOnBox;
  final String text;
  GetStorage box = GetStorage();

  MessageCreater(
      {required this.title, required this.keyOnBox, required this.text});

  final _formKey = GlobalKey<FormState>();
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(title),
          trailing: IconButton(
              onPressed: () {
                if (box.read(keyOnBox) == null) {
                  editingController = TextEditingController(text: text);
                  box.write(keyOnBox, text);
                } else {
                  editingController =
                      TextEditingController(text: box.read(keyOnBox));
                }
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
                          height: Get.height / 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(),
                                            Text(
                                              "Xabar yaratish",
                                              style: appBarStyle.copyWith(
                                                  fontSize: 14),
                                            ),
                                            IconButton(
                                                onPressed: Get.back,
                                                icon: Icon(
                                                  Icons.close,
                                                  color: CupertinoColors.black,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                      controller: editingController,
                                      minLines: 5,
                                      maxLines: 10,
                                      keyboardType: TextInputType.text,
                                      decoration: buildInputDecoratione(""),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Maydonlar bo'sh bo'lmasligi kerak";
                                        }
                                        return null;
                                      }),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  box.write(
                                      keyOnBox, "${editingController.text}");

                                  Get.back();
                                },
                                child: CustomButton(text: "Tasdiqlash"),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.edit)),
        ));
  }
}
