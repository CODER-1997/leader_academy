
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/screens/admin/teachers/teacherInfo.dart';
import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/custom_dialog.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../controllers/admin/teachers_controller.dart';
import '../../../controllers/auth/login_controller.dart';
import '../../../controllers/students/student_controller.dart';

class Teachers extends StatefulWidget {
  @override
  State<Teachers> createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  final _formKey = GlobalKey<FormState>();

  TeachersController teachersController = Get.put(TeachersController());
  StudentController studentController = Get.put(StudentController());

  String _searchText = '';
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          actions:  [
            box.read('isLogged') == '004422' ? Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: FilledButton.icon(
                  onPressed: () {
                    studentController.fetchGroups();
                    teachersController.teacherGroups.clear();
                    teachersController.teacherGroupIds.clear();
                    teachersController.TeacherSurname.clear();
                    teachersController.TeacherName.clear();

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
                              height: Get.height / 1.6,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                SizedBox(),
                                                Text(
                                                  "Ustoz yaratish",
                                                  style: appBarStyle.copyWith(
                                                      fontSize: 14),
                                                ),
                                                IconButton(
                                                    onPressed: Get.back,
                                                    icon: Icon(
                                                      Icons.close,
                                                      color:
                                                      CupertinoColors.black,
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
                                          controller:
                                          teachersController.TeacherName,
                                          keyboardType: TextInputType.text,
                                          decoration: buildInputDecoratione(
                                              "Ustoz ismi"),
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
                                          controller:
                                          teachersController.TeacherSurname,
                                          keyboardType: TextInputType.text,
                                          decoration: buildInputDecoratione(
                                              'Ustoz familiyasi'),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Maydonlar bo'sh bo'lmasligi kerak";
                                            }
                                            return null;
                                          }),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Text(
                                        'Guruh biriktirish',
                                        style:
                                        appBarStyle.copyWith(fontSize: 16),
                                      ),
                                      Obx(() => Container(
                                        height: 100,
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
                                                GestureDetector(
                                                  onTap: () {

                                                    if (teachersController.teacherGroupIds.contains(studentController.LeaderGroups[i]['group_id'])) {
                                                      teachersController .teacherGroupIds.remove(studentController.LeaderGroups[i]['group_id']);
                                                      teachersController.teacherGroups.removeWhere((el)=> el['group_id']== studentController.LeaderGroups[i]['group_id']);
                                                      print('Teacher groups ${ teachersController.teacherGroups}');
                                                    } else {
                                                      teachersController.teacherGroups.add(studentController.LeaderGroups[i]);
                                                      teachersController.teacherGroupIds.add(studentController.LeaderGroups[i]['group_id']);
                                                      print('Teacher groups ${ teachersController.teacherGroups}');

                                                    }

                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 18,
                                                        vertical: 8),
                                                    margin:
                                                    EdgeInsets.all(8),
                                                    decoration: !teachersController
                                                        .teacherGroupIds
                                                        .contains(studentController
                                                        .LeaderGroups[i][
                                                    'group_id'])
                                                        ? BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            112),
                                                        border: Border.all(
                                                            color: Colors
                                                                .black,
                                                            width: 1))
                                                        : BoxDecoration(
                                                        color: Colors
                                                            .green,
                                                        borderRadius:
                                                        BorderRadius.circular(112),
                                                        border: Border.all(color: Colors.green, width: 1)),
                                                    child: Text(
                                                      "${studentController.LeaderGroups[i]['group_name']}",
                                                      style: TextStyle(
                                                          color: !teachersController
                                                              .teacherGroupIds
                                                              .contains(
                                                              studentController.LeaderGroups[i]
                                                              [
                                                              'group_id'])
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
                                      if (_formKey.currentState!.validate()) {
                                        teachersController.addNewTeacher();
                                      }
                                    },
                                    child: Obx(() => CustomButton(
                                        isLoading:
                                        teachersController.isLoading.value,
                                        text: "Qo'shish")),
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
                  label: Text("Ustoz yaratish")),
            ):SizedBox(),

          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: buildInputDecoratione('Qidirish'),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.toLowerCase();
                    });
                  },
                ),
                SizedBox(height: 8,),
                StreamBuilder(
                    stream: _searchText.isEmpty
                        ? FirebaseFirestore.instance
                        .collection('LeaderTeachers')
                        .snapshots()
                        : FirebaseFirestore.instance
                        .collection('LeaderTeachers')
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
                        var teachers = snapshot.data!.docs;

                        return teachers.length != 0
                            ? Column(
                          children: [
                            for (int i = 0; i < teachers.length; i++)
                              InkWell(
                                onTap: () {
                                  if(box.read('isLogged') == '004422'){
                                    Get.to(Teacherinfo(
                                      documentId: teachers[i].id,
                                    ));
                                  }
                                  else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('Sizga ruxsat yoq'
                                          .tr
                                          .capitalizeFirst!),
                                      backgroundColor: Colors.green,
                                      dismissDirection:
                                      DismissDirection.startToEnd,
                                    ));
                                  }

                                },
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      color: CupertinoColors.white),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                              radius: 24,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    111),
                                                child: Image.asset(
                                                    'assets/teacher_avatar.png'),
                                              )),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            teachers[i]['items']['name']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                            teachers[i]['items']
                                            ['surname']
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                  box.read("isLogged") == "004422"?    Row(
                                        children: [
                                          SizedBox(
                                            width: 16,
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                teachersController.teacherGroupsEdit.clear();
                                                teachersController. teacherGroupIdsEdit.clear();
                                                studentController.fetchGroups();


                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                  context) {
                                                    teachersController
                                                        .setValues(
                                                        teachers[i][
                                                        'items']
                                                        ['name'],
                                                        teachers[i]
                                                        [
                                                        'items']
                                                        [
                                                        'surname']);
                                                    teachersController.teacherGroupIdsEdit.addAll(teachers[i]['items'] ['groupIds']);
                                                    teachersController.teacherGroupsEdit.addAll(teachers[i]['items'] ['groups']);

                                                    return Dialog(
                                                      backgroundColor:
                                                      Colors.white,
                                                      insetPadding:
                                                      EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          16),

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
                                                          height:
                                                          Get.height /
                                                              2,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        "Tahrirlash",
                                                                        style: appBarStyle,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                    16,
                                                                  ),
                                                                  TextFormField(
                                                                      decoration:
                                                                      buildInputDecoratione(''),
                                                                      controller: teachersController.TeacherNameEdit,
                                                                      keyboardType: TextInputType.text,
                                                                      validator: (value) {
                                                                        if (value!.isEmpty) {
                                                                          return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                        }
                                                                        return null;
                                                                      }),
                                                                  SizedBox(
                                                                    height:
                                                                    16,
                                                                  ),
                                                                  TextFormField(
                                                                      decoration:
                                                                      buildInputDecoratione(''),
                                                                      controller: teachersController.TeacherSurnameEdit,
                                                                      keyboardType: TextInputType.text,
                                                                      validator: (value) {
                                                                        if (value!.isEmpty) {
                                                                          return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                        }
                                                                        return null;
                                                                      }),
                                                                  SizedBox(
                                                                    height:
                                                                    16,
                                                                  ),
                                                                  Text(
                                                                    'Tahrirlash',
                                                                    style:
                                                                    appBarStyle,
                                                                  ),
                                                                  Obx(() =>
                                                                  studentController.loadGroups.value == false ?    Container(
                                                                    height: 100,
                                                                    alignment: Alignment.topLeft,
                                                                    child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Row(
                                                                        children: [
                                                                          for (int i = 0; i < studentController.LeaderGroups.length; i++)
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                if (teachersController.teacherGroupIdsEdit.contains(studentController.LeaderGroups[i]['group_id'])) {
                                                                                  teachersController.teacherGroupIdsEdit.remove(studentController.LeaderGroups[i]['group_id']);
                                                                                  teachersController.teacherGroupsEdit.removeWhere((el)=> el['group_id'] == studentController.LeaderGroups[i]['group_id']);
                                                                                  print("Edited groups ${teachersController.teacherGroupsEdit}");

                                                                                } else {
                                                                                  teachersController.teacherGroupIdsEdit.add(studentController.LeaderGroups[i]['group_id']);
                                                                                  teachersController.teacherGroupsEdit.add(studentController.LeaderGroups[i]);
                                                                                  print("Edited groups ${teachersController.teacherGroupsEdit}");

                                                                                }

                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                                                                margin: EdgeInsets.all(8),
                                                                                decoration: !teachersController.teacherGroupIdsEdit.contains(studentController.LeaderGroups[i]['group_id']) ? BoxDecoration(borderRadius: BorderRadius.circular(112), border: Border.all(color: Colors.black, width: 1)) : BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(112), border: Border.all(color: Colors.green, width: 1)),
                                                                                child: Text(
                                                                                  "${studentController.LeaderGroups[i]['group_name']}",
                                                                                  style: TextStyle(color: !teachersController.teacherGroupIdsEdit.contains(studentController.LeaderGroups[i]['group_id']) ? Colors.black : CupertinoColors.white),
                                                                                ),
                                                                              ),
                                                                            )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ) : Container(

                                                                      padding: EdgeInsets.all(16),
                                                                      alignment: Alignment.center,
                                                                      child: Text("Loading groups . ")) )
                                                                ],
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    ()   {

                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    teachersController.editTeacher(teachers[i]
                                                                        .id
                                                                        .toString());
                                                                  }
                                                                },
                                                                child: Obx(() => CustomButton(
                                                                    isLoading: teachersController
                                                                        .isLoading
                                                                        .value,
                                                                    text:
                                                                    "Tahrirlash")),
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
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                  context) {
                                                    return CustomAlertDialog(
                                                      title:
                                                      "Ustozni o'chirish",
                                                      description:
                                                      "Rostdanham o'chirasizmi",
                                                      onConfirm:
                                                          () async {
                                                        // Perform delete action here
                                                        teachersController
                                                            .deleteTeacher(
                                                            teachers[
                                                            i]
                                                                .id);
                                                      },
                                                      img:
                                                      'assets/delete.png',
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                        ],
                                      ):SizedBox()
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
                                width: 122,
                              ),
                              Text(
                                'Ustozlar mavjud emas',
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
