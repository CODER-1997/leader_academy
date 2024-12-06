import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/constants/custom_widgets/student_card.dart';
import 'package:leader/screens/admin/students/student_info.dart';
import 'package:leader/screens/admin/students/student_payment_history.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/custom_dialog.dart';
import '../../../constants/custom_widgets/emptiness.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';

class AdminStudents extends StatefulWidget {
  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {
  final _formKey = GlobalKey<FormState>();

  StudentController studentController = Get.put(StudentController());

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: FilledButton.icon(
                  onPressed: () {
                    studentController.fetchGroups();
                    studentController.selectedGroup.value = "";
                    studentController.selectedGroupId.value = "";

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
                              height: Get.height / 1.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text("Add Student"),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      TextFormField(
                                          controller: studentController.name,
                                          keyboardType: TextInputType.text,
                                          decoration: buildInputDecoratione(
                                              'Student name'
                                                      .tr
                                                      .capitalizeFirst! ??
                                                  ''),
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
                                              'Student surname'
                                                      .tr
                                                      .capitalizeFirst! ??
                                                  ''),
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
                                        keyboardType: TextInputType.text,
                                        decoration: buildInputDecoratione(
                                            'Student phone'
                                                    .tr
                                                    .capitalizeFirst! ??
                                                ''),
                                        // validator: (value) {
                                        //   if (value!.isEmpty) {
                                        //     return "Maydonlar bo'sh bo'lmasligi kerak";
                                        //   }
                                        //   return null;
                                        // },
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        children: [
                                          Obx(
                                            () => Text(
                                                'Started date:  ${studentController.paidDate.value}'),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                studentController.showDate(
                                                    studentController.paidDate);
                                              },
                                              icon: Icon(Icons.calendar_month))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Choose Group',
                                            style: appBarStyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Obx(() => Container(
                                            alignment: Alignment.topLeft,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          studentController
                                                              .LeaderGroups
                                                              .length;
                                                      i++)
                                                    InkWell(
                                                      onTap: () {
                                                        studentController
                                                                .selectedGroup
                                                                .value =
                                                            studentController
                                                                    .LeaderGroups[
                                                                i]['group_name'];
                                                        studentController
                                                                .selectedGroupId
                                                                .value =
                                                            studentController
                                                                    .LeaderGroups[
                                                                i]['group_id'];
                                                        print(studentController
                                                            .selectedGroupId
                                                            .value);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 18,
                                                                vertical: 8),
                                                        margin:
                                                            EdgeInsets.all(8),
                                                        decoration: studentController
                                                                    .selectedGroupId
                                                                    .value !=
                                                                studentController.LeaderGroups[i]
                                                                    ['group_id']
                                                            ? BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                    112),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1))
                                                            : BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        112),
                                                                border: Border.all(
                                                                    color: Colors.green,
                                                                    width: 1)),
                                                        child: Text(
                                                          "${studentController.LeaderGroups[i]['group_name']}",
                                                          style: TextStyle(
                                                              color: studentController
                                                                          .selectedGroupId
                                                                          .value !=
                                                                      studentController
                                                                              .LeaderGroups[i]
                                                                          [
                                                                          'group_id']
                                                                  ? Colors.black
                                                                  : CupertinoColors
                                                                      .white),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_formKey.currentState!.validate() &&
                                          studentController.selectedGroupId
                                              .value.isNotEmpty) {
                                        print(studentController
                                            .selectedGroupId.value);
                                        studentController.addNewStudent([studentController.selectedGroupId.value]);
                                      }
                                      if (studentController
                                          .selectedGroup.value.isEmpty) {
                                        Get.snackbar(
                                          'Error',
                                          "You have to choose one of the groups",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                        );
                                      }
                                    },
                                    child: Obx(() => CustomButton(
                                        isLoading:
                                            studentController.isLoading.value,
                                        text: "Add".tr.capitalizeFirst!)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add student")),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: buildInputDecoratione('Search students'),
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
              ),
              SizedBox(height: 4),
              Expanded(
                child: StreamBuilder(
                    stream: _searchText.isEmpty
                        ? FirebaseFirestore.instance
                            .collection('LeaderStudents')
                        .where('items.isDeleted', isEqualTo: false).snapshots()
                        : FirebaseFirestore.instance
                            .collection('LeaderStudents')
                            .where('items.name' ,
                                isGreaterThanOrEqualTo: _searchText)
                            .where('items.name',
                                isLessThanOrEqualTo: _searchText + '\uf8ff')
                             .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.hasData) {
                        var students = snapshot.data!.docs;

                        for(var item in students){
                          if(item['items']['exams'] == null){
                            studentController.addNewFeature(item.id);
                          }
                        }

                        return students.length != 0
                            ? ListView.builder(
                                itemCount: students.length,
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(StudentInfo(
                                          studentId: students[i].id));
                                    },
                                    child: StudentCard(
                                      item: students[i]['items'],
                                    ),
                                  );
                                })
                            : Emptiness(title: 'Our center has not any students ');
                      }
                      // If no data available
                        
                      else {
                        return Text('No data'); // No data available
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
