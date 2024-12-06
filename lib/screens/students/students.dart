import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../constants/custom_widgets/custom_dialog.dart';
import '../../constants/custom_widgets/gradient_button.dart';
import '../../constants/text_styles.dart';
import '../../constants/theme.dart';
import '../../constants/utils.dart';
import '../../controllers/students/student_controller.dart';

class Students extends StatefulWidget {
  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
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
              padding: const EdgeInsets.only(right: 16,),
              child:FilledButton.icon(
                  onPressed: () {
                    studentController.fetchGroups();
                    studentController.selectedGroup.value = "";
                    studentController.selectedGroupId.value = "";
                    studentController.phone.clear();
                    studentController.surname.clear();
                    studentController.name.clear();

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          insetPadding: EdgeInsets.symmetric(horizontal: 4),
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
                              height: Get.height*.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(),
                                          Text("Add Student"),
                                          IconButton(onPressed: Get.back, icon: Icon(Icons.close))
                                        ],
                                      ),
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
                                        keyboardType: TextInputType.phone,

                                        decoration: buildInputDecoratione(
                                            '+998 90 123 45 67'
                                                .tr
                                                .capitalizeFirst! ??
                                                ''),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Maydonlar bo'sh bo'lmasligi kerak";
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 16,),
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
                                                        .LeaderGroups[i]['group_name'];
                                                    studentController
                                                        .selectedGroupId
                                                        .value =
                                                    studentController
                                                        .LeaderGroups[i]['group_id'];
                                                    print(studentController.selectedGroupId.value);
                                                  },
                                                  child: Container(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 18,
                                                        vertical: 8),
                                                    margin: EdgeInsets.all(8),
                                                    decoration: studentController
                                                        .selectedGroupId
                                                        .value !=
                                                        studentController
                                                            .LeaderGroups[
                                                        i]['group_id']
                                                        ? BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            112),
                                                        border: Border.all(
                                                            color: Colors
                                                                .black,
                                                            width: 1))
                                                        : BoxDecoration(
                                                        color:
                                                        Colors.green,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            112),
                                                        border: Border.all(
                                                            color: Colors.green,
                                                            width: 1)),
                                                    child: Text(
                                                      "${studentController.LeaderGroups[i]['group_name']}"
                                                      ,
                                                      style: TextStyle(
                                                          color: studentController
                                                              .selectedGroupId
                                                              .value !=
                                                              studentController
                                                                  .LeaderGroups[
                                                              i]['group_id']
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
                                      if (_formKey.currentState!.validate() && studentController.selectedGroupId.value.isNotEmpty ) {
                                       print(studentController.selectedGroupId.value);
                                        studentController.addNewStudent([studentController.selectedGroupId.value]);
                                      }
                                      if(studentController.selectedGroup.value.isEmpty){
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
        body: SingleChildScrollView(
          child: Padding(
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
                SizedBox(height: 20),
                StreamBuilder(
                    stream: _searchText.isEmpty
                        ? FirebaseFirestore.instance
                            .collection('LeaderStudents')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('LeaderStudents')
                            .where('items.name',
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
                        var students = snapshot.data!.docs
                            .where((el) =>
                        el['items']['isDeleted'] ==
                            false)
                            .toList();


                        return students.length != 0
                            ? Column(
                                children: [
                                  for (int i = 0; i < students.length; i++)
                                    GestureDetector(
                                      onTap: () {
                                        // Get.to(StudentPaymentHistory(
                                        //   uniqueId:
                                        //       '${students[i]['items']['uniqueId']}',
                                        //   id: students[i].id,
                                        //   name: students[i]['items']['name'],
                                        //   surname: students[i]['items']
                                        //       ['surname'],
                                        // ));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                            color: CupertinoColors.white),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                FittedBox(
                                                  child: Container(
                                                    width: Get.width/2.5,
                                                    child: Text(students[i]['items']
                                                                ['name']
                                                            .toString()
                                                            .capitalizeFirst! +
                                                        " " +
                                                        students[i]['items']
                                                                ['surname']
                                                            .toString()
                                                            .capitalizeFirst!,
                                                      overflow: TextOverflow.ellipsis,

                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                // show status has debt
                                                // SizedBox(width: 16,),
                                                // Visibility(
                                                //   visible: hasDebt(students[i]['items']
                                                //   ['payments']),
                                                //   child: Container(
                                                //     padding: EdgeInsets.all(16),
                                                //     decoration: BoxDecoration(
                                                //       color: Colors.red,
                                                //     border: Border.all(color: Colors.red,width: 1),
                                                //     borderRadius: BorderRadius.circular(102)
                                                //   ),
                                                //   child: Text("Fee unpaid",style: appBarStyle.copyWith(color: Colors.white,fontSize: 16),),
                                                //   ),
                                                // ),
                                                // SizedBox(width: 16,),
                                                IconButton(
                                                    onPressed: () {
                                                      studentController.fetchGroups();
                                                      studentController.selectedGroupId.value = students[i]['items']['groupId'];
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          studentController
                                                              .setValues(
                                                            students[i]['items']
                                                                ['name'],
                                                            students[i]['items']
                                                                ['surname'],
                                                            students[i]['items']
                                                                ['phone'],
                                                          );

                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            insetPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2),

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
                                                                    EdgeInsets
                                                                        .all(
                                                                            16),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12)),
                                                                width:
                                                                    Get.width,
                                                                height: Get.height*.7,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SizedBox(),
                                                                            Text("Edit"),
                                                                            IconButton(onPressed: Get.back, icon: Icon(Icons.close))
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          child: TextFormField(
                                                                              decoration: buildInputDecoratione(''),
                                                                              controller: studentController.nameEdit,
                                                                              keyboardType: TextInputType.text,
                                                                              validator: (value) {
                                                                                if (value!.isEmpty) {
                                                                                  return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                                }
                                                                                return null;
                                                                              }),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          child:
                                                                              TextFormField(
                                                                            controller:
                                                                                studentController.surnameEdit,
                                                                            keyboardType:
                                                                                TextInputType.text,
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                buildInputDecoratione(''.tr.capitalizeFirst! ?? ''),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        SizedBox(
                                                                          child:
                                                                              TextFormField(
                                                                              controller:
                                                                                studentController.phoneEdit,
                                                                            keyboardType: TextInputType.phone,
                                                                            validator:
                                                                                (value) {
                                                                              if (value!.isEmpty) {
                                                                                return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                              }
                                                                              return null;
                                                                            },
                                                                            decoration:
                                                                                buildInputDecoratione('+998 90 123 45 67'.tr.capitalizeFirst! ?? ''),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 16,),
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
                                                                          height:
                                                                              16,
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
                                                                          height:
                                                                              16,
                                                                        ),
                                                                        Obx(() =>
                                                                            Container(
                                                                              alignment: Alignment.topLeft,
                                                                              child: SingleChildScrollView(
                                                                                scrollDirection: Axis.horizontal,
                                                                                child: Row(
                                                                                  children: [
                                                                                    for (int i = 0; i < studentController.LeaderGroups.length; i++)

                                                                                      GestureDetector(
                                                                                        onTap: () {

                                                                                          studentController
                                                                                              .selectedGroup
                                                                                              .value =
                                                                                          studentController
                                                                                              .LeaderGroups[i]['group_name'];
                                                                                          studentController
                                                                                              .selectedGroupId
                                                                                              .value =
                                                                                          studentController
                                                                                              .LeaderGroups[i]['group_id'];

                                                                                          },
                                                                                        child: Container(
                                                                                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                                                                          margin: EdgeInsets.all(8),
                                                                                          decoration: studentController.selectedGroupId.value != studentController.LeaderGroups[i]['group_id']  ?
                                                                                          BoxDecoration(borderRadius: BorderRadius.circular(112), border: Border.all(color: Colors.black, width: 1)) : BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(112), border: Border.all(color: Colors.green, width: 1)),
                                                                                          child: Text(
                                                                                            "${studentController.LeaderGroups[i]['group_name']}",
                                                                                            style: TextStyle(color: studentController.selectedGroupId.value != studentController.LeaderGroups[i]['group_id'] ? Colors.black : CupertinoColors.white),
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
                                                                      onTap:
                                                                          () {
                                                                        if (_formKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          studentController.editStudent(students[i]
                                                                              .id
                                                                              .toString());
                                                                        }
                                                                      },
                                                                      child: Obx(() => CustomButton(
                                                                          isLoading: studentController
                                                                              .isLoading
                                                                              .value,
                                                                          text: "Edit"
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
                                                    icon: Icon(Icons.edit,color: Colors.green,),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomAlertDialog(
                                                          title:
                                                              "Delete Student",
                                                          description:
                                                              "Are you sure you want to delete this student?",
                                                          onConfirm: () async {
                                                            // Perform delete action here
                                                            studentController
                                                                .deleteStudent(
                                                                    students[i]
                                                                        .id);
                                                          },
                                                          img:'assets/delete.png',
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(Icons.delete,color: Colors.red,),

                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: Get.height/5,),
                                    Image.asset(
                                      'assets/empty.png',
                                      width: 111,
                                    ),
                                    Text(
                                      'Our center has not any students ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              );
                      }
                      // If no data available

                      else {
                        return Text('No data'); // No data available
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
