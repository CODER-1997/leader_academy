import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/controllers/auth/login_controller.dart';
import '../../constants/theme.dart';
import '../../controllers/groups/group_controller.dart';
import '../../controllers/students/student_controller.dart';
import '../students_by_group/students_by_group.dart';

class Groups extends StatefulWidget {
  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {

  GroupController groupController = Get.put(GroupController());
  FireAuth authController = Get.put(FireAuth());
  StudentController studentController = Get.put(StudentController());

  var box = GetStorage();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          actions: [

            IconButton(
                onPressed: () {
                  authController.logOut();
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
            SizedBox(
              width: 8,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('LeaderTeachers')
                        .doc("${box.read('teacherDocId')}")
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Container(
                            width: Get.width,
                            height: Get.height-120,
                            child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                  Text('No teacher found'),
                                  ],
                                ));
                      }
                      // Extract the document data
                      Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                      if (snapshot.hasData) {

                        return data['items']['groups'].length != 0
                            ? Column(
                                children: [
                        for (int i = 0; i < data['items']['groups'] .toList()  .length;  i++)
                                    InkWell(
                                      onTap: () {
                                        authController.isBanned.value = data['items']['isBanned'];

                                        if(  authController.isBanned.value == true) {
                                          Get.snackbar(
                                            duration: Duration(seconds: 5),
                                            icon: Icon(Icons.block,color: Colors.white,),
                                            "Xatolik",
                                            "Akkaunt bloklangan",
                                            snackPosition: SnackPosition.TOP,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }

                                       else {
                                          Get.to(
                                              StudentsByGroup(
                                              groupName: data['items']['groups'][i]['group_name'],
                                              groupId: data['items']['groups'][i]['group_id'],
                                                groupDocId: snapshot.data!.id,
                                                subject: data['items']['groups'][i]['subject'],
                                          ));
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(4),
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
                                                          'assets/logo.png'),
                                                    )),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Text(
                                                  data['items']['groups'][i]['group_name'],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                // IconButton(
                                                //     onPressed: () {
                                                //       showDialog(
                                                //         context: context,
                                                //         builder: (BuildContext
                                                //             context) {
                                                //           groupController
                                                //               .setValues(
                                                //             data['items'][
                                                //                     'groups'][i]
                                                //                 ['group_name'],
                                                //           );
                                                //
                                                //           return Dialog(
                                                //             backgroundColor:
                                                //                 Colors.white,
                                                //
                                                //             shape: RoundedRectangleBorder(
                                                //                 borderRadius:
                                                //                     BorderRadius
                                                //                         .circular(
                                                //                             12.0)),
                                                //             //this right here
                                                //             child: Form(
                                                //               key: _formKey,
                                                //               child: Container([
                                                //                 padding:
                                                //                     EdgeInsets
                                                //                         .all(
                                                //                             16),
                                                //                 decoration: BoxDecoration(
                                                //                     color: Colors
                                                //                         .white,
                                                //                     borderRadius:
                                                //                         BorderRadius.circular(
                                                //                             12)),
                                                //                 width:
                                                //                     Get.width,
                                                //                 height: 220,
                                                //                 child: Column(
                                                //                   mainAxisAlignment:
                                                //                       MainAxisAlignment
                                                //                           .spaceBetween,
                                                //                   children: [
                                                //                     Column(
                                                //                       children: [
                                                //                         Text(
                                                //                             "Tahrirlash"),
                                                //                         SizedBox(
                                                //                           height:
                                                //                               16,
                                                //                         ),
                                                //                         SizedBox(
                                                //                           child: TextFormField(
                                                //                               decoration: buildInputDecoratione(''),
                                                //                               controller: groupController.GroupEdit,
                                                //                               keyboardType: TextInputType.text,
                                                //                               validator: (value) {
                                                //                                 if (value!.isEmpty) {
                                                //                                   return "Maydonlar bo'sh bo'lmasligi kerak";
                                                //                                 }
                                                //                                 return null;
                                                //                               }),
                                                //                         ),
                                                //                         SizedBox(
                                                //                           height:
                                                //                               16,
                                                //                         ),
                                                //                       ],
                                                //                     ),
                                                //                     // InkWell(
                                                //                     //   onTap:
                                                //                     //       () {
                                                //                     //     if (_formKey
                                                //                     //         .currentState!
                                                //                     //         .validate()) {
                                                //                     //       groupController.editGroup(groups[i]
                                                //                     //           .id
                                                //                     //           .toString());
                                                //                     //     }
                                                //                     //   },
                                                //                     //   child: Obx(() => CustomButton(
                                                //                     //       isLoading: groupController
                                                //                     //           .isLoading
                                                //                     //           .value,
                                                //                     //       text:
                                                //                     //           "Edit")),
                                                //                     // )
                                                //                   ],
                                                //                 ),
                                                //               ),
                                                //             ),
                                                //           );
                                                //         },
                                                //       );
                                                //     },
                                                //     icon: Icon(Icons.edit)),
                                                // IconButton(
                                                //     onPressed: () {
                                                //       showDialog(
                                                //         context: context,
                                                //         builder: (BuildContext
                                                //             context) {
                                                //           return CustomAlertDialog(
                                                //             title:
                                                //                 "Delete Group",
                                                //             description:
                                                //                 "Are you sure you want to delete this group ?",
                                                //             onConfirm:
                                                //                 () async {
                                                //               // Perform delete action here
                                                //               groupController
                                                //                   .deleteGroup(
                                                //                       groups[i]
                                                //                           .id);
                                                //             },
                                                //             img:
                                                //                 'assets/delete.png',
                                                //           );
                                                //         },
                                                //       );
                                                //     },
                                                //     icon: Icon(
                                                //       Icons.delete,
                                                //       color: Colors.red,
                                                //     ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              )
                            : Container(
                          height: Get.height/1.5,
                              child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/empty.png',
                                        width: 122,
                                      ),
                                      SizedBox(height: 16,),
                                      Text(
                                        'You have not groups ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
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
