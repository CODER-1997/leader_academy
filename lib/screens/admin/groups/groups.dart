import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:leader/constants/custom_widgets/last_seen_widget.dart';
import 'package:leader/controllers/auth/login_controller.dart';
import 'package:get_storage/get_storage.dart';
import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/custom_dialog.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../controllers/groups/group_controller.dart';
import '../../../main.dart';
import '../../students_by_group/students_by_group.dart';

class AdminGroups extends StatefulWidget {
  @override
  State<AdminGroups> createState() => _AdminGroupsState();
}

class _AdminGroupsState extends State<AdminGroups> {
  final _formKey = GlobalKey<FormState>();

  GroupController groupController = Get.put(GroupController());

  FireAuth auth = Get.put(FireAuth());

  int order = 0;
  GetStorage box = GetStorage();

  void _updateOrder(
      List<QueryDocumentSnapshot> documents, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final movedDocument = documents.removeAt(oldIndex);
    documents.insert(newIndex, movedDocument);

    // Update Firestore with the new order
    for (int i = 0; i < documents.length; i++) {
      FirebaseFirestore.instance
          .collection('LeaderGroups')
          .doc(documents[i].id)
          .update({'items.order': i});
    }
  }

  @override
  void initState() {
    print("Shorebird ${shorebirdCodePush.isShorebirdAvailable()}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        backgroundColor: dashBoardColor,
        toolbarHeight: 64,
        title: Text(
          "Leader",
          style: appBarStyle.copyWith(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
            ),
            child: InkWell(
              onTap: () {
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
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          width: Get.width,
                          height: Get.height / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("Add Group"),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  TextFormField(
                                      controller: groupController.GroupName,
                                      keyboardType: TextInputType.text,
                                      decoration:
                                          buildInputDecoratione('Group name'),
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
                                  if (_formKey.currentState!.validate()) {
                                    groupController.addNewGroup();
                                  }
                                },
                                child: Obx(() => CustomButton(
                                    isLoading: groupController.isLoading.value,
                                    text: "Add")),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Add group",
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: Color(0xffff5f91),
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (box.read('passcode') == null) {
                  screenLockCreate(
                    inputController: InputController(),
                    context: context,
                    onConfirmed: (String value) {
                      box.write('passcode', value);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Password created'.tr.capitalizeFirst!),
                        backgroundColor: Colors.green,
                        dismissDirection: DismissDirection.startToEnd,
                      ));
                    },
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
                                    'Do you want to update your passcode',
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
                                      screenLockCreate(
                                        inputController: InputController(),
                                        context: context,
                                        onConfirmed: (String value) {
                                          box.write('passcode', value);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Password updated'
                                                .tr
                                                .capitalizeFirst!),
                                            backgroundColor: Colors.green,
                                            dismissDirection:
                                                DismissDirection.startToEnd,
                                          ));
                                        },
                                      );
                                    },
                                    child: Text(
                                      'update'.tr.capitalizeFirst!,
                                      style: appBarStyle.copyWith(
                                          color: Colors.green),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        box.write('passcode', null);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'remove'.tr.capitalizeFirst!,
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
              icon: Icon(
                Icons.lock,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                auth.logOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LeaderGroups')
                .orderBy('items.order')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                var groups = snapshot.data!.docs;
                groupController.order.value = groups.length + 1;
                List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                return ReorderableListView(
                  onReorder: (oldIndex, newIndex) =>
                      _updateOrder(documents, oldIndex, newIndex),
                  children: [
                    for (int i = 0; i < documents.length; i++)
                      Container(
                        key: ValueKey(documents[i].id),
                        child: InkWell(
                          onTap: () {
                            Get.to(StudentsByGroup(
                              groupId: documents[i]['items']['uniqueId'],
                              groupName: documents[i]['items']['name'],
                              groupDocId: documents[i].id,
                            ));
                          },
                          child: Container(
                            width: Get.width,
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: CupertinoColors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: Colors.teal,
                                            radius: 16,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(111),
                                              child: Text(
                                                "${i + 1}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            )),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          documents[i]['items']['name']
                                              .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        )
                                      ],
                                    ),
                                    documents[i]['items']['smsSentDate'] !=
                                                null ||
                                            documents[i]['items']['smsSentDate']
                                                    .toString()
                                                    .length >
                                                6
                                        ? LastSeenWidget(
                                            dateTime:DateFormat("dd-MM-yyyy").parse( documents[i]['items']
                                                    ['smsSentDate']
                                                .toString()).toString())
                                        : SizedBox()
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            groupController.setValues(
                                              documents[i]['items']['name'],
                                            );

                                            return Dialog(
                                              backgroundColor: Colors.white,
                                              insetPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16),

                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0)),
                                              //this right here
                                              child: Form(
                                                key: _formKey,
                                                child: Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                  width: Get.width,
                                                  height: Get.height / 3,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text("Tahrirlash"),
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                          SizedBox(
                                                            child:
                                                                TextFormField(
                                                                    decoration:
                                                                        buildInputDecoratione(
                                                                            ''),
                                                                    controller:
                                                                        groupController
                                                                            .GroupEdit,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    validator:
                                                                        (value) {
                                                                      if (value!
                                                                          .isEmpty) {
                                                                        return "Maydonlar bo'sh bo'lmasligi kerak";
                                                                      }
                                                                      return null;
                                                                    }),
                                                          ),
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                        ],
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            groupController
                                                                .editGroup(
                                                                    documents[i]
                                                                        .id
                                                                        .toString());
                                                          }
                                                        },
                                                        child: Obx(() =>
                                                            CustomButton(
                                                                isLoading:
                                                                    groupController
                                                                        .isLoading
                                                                        .value,
                                                                text: "Edit")),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(Icons.edit),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomAlertDialog(
                                                title: "Delete Group",
                                                description:
                                                    "Are you sure you want to delete this group ?",
                                                onConfirm: () async {
                                                  // Perform delete action here
                                                  groupController.deleteGroup(
                                                      documents[i].id);
                                                },
                                                img: 'assets/delete.png',
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                );
                // return groups.length != 0
                //     ? Wrap(
                //         alignment: WrapAlignment.start,
                //         spacing: 8,
                //         direction: Axis.horizontal,
                //         children: [
                //           for (int i = 0; i < groups.length; i++)
                //             InkWell(
                //               onTap: () {
                //                 Get.to(StudentsByGroup(
                //                   groupId: groups[i]['items']['uniqueId'],
                //                   groupName: groups[i]['items']['name'],
                //                 ));
                //               },
                //               child: Container(
                //                 width: Get.width,
                //                 padding: EdgeInsets.all(12),
                //                 margin: EdgeInsets.all(2),
                //                 decoration: BoxDecoration(
                //                     borderRadius:
                //                         BorderRadius.circular(8),
                //                     color: CupertinoColors.white),
                //                 child: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     Row(
                //                       children: [
                //                         CircleAvatar(
                //                             backgroundColor:
                //                                 Colors.teal,
                //                             radius: 16,
                //                             child: ClipRRect(
                //                               borderRadius:
                //                                   BorderRadius.circular(
                //                                       111),
                //                               child: Text(
                //                                 "${ groups[i]['items']['order']}",
                //                                 style: TextStyle(
                //                                     color: Colors.white),
                //                               ),
                //                             )),
                //                         SizedBox(
                //                           width: 8,
                //                         ),
                //                         Text(
                //                           groups[i]['items']['name']
                //                               .toString(),
                //                           style: TextStyle(
                //                             fontWeight: FontWeight.w700,
                //                             color: Colors.black,
                //                             fontSize: 14,
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                     Row(
                //                       children: [
                //                         InkWell(
                //                           onTap: () {
                //                             showDialog(
                //                               context: context,
                //                               builder:
                //                                   (BuildContext context) {
                //                                 groupController.setValues(
                //                                   groups[i]['items']
                //                                       ['name'],
                //                                 );
                //
                //                                 return Dialog(
                //                                   backgroundColor:
                //                                       Colors.white,
                //                                   insetPadding: EdgeInsets
                //                                       .symmetric(
                //                                           horizontal: 16),
                //
                //                                   shape: RoundedRectangleBorder(
                //                                       borderRadius:
                //                                           BorderRadius
                //                                               .circular(
                //                                                   12.0)),
                //                                   //this right here
                //                                   child: Form(
                //                                     key: _formKey,
                //                                     child: Container(
                //                                       padding:
                //                                           EdgeInsets.all(
                //                                               16),
                //                                       decoration: BoxDecoration(
                //                                           color: Colors
                //                                               .white,
                //                                           borderRadius:
                //                                               BorderRadius
                //                                                   .circular(
                //                                                       12)),
                //                                       width: Get.width,
                //                                       height:
                //                                           Get.height / 3,
                //                                       child: Column(
                //                                         mainAxisAlignment:
                //                                             MainAxisAlignment
                //                                                 .spaceBetween,
                //                                         children: [
                //                                           Column(
                //                                             children: [
                //                                               Text(
                //                                                   "Tahrirlash"),
                //                                               SizedBox(
                //                                                 height:
                //                                                     16,
                //                                               ),
                //                                               SizedBox(
                //                                                 child: TextFormField(
                //                                                     decoration: buildInputDecoratione(''),
                //                                                     controller: groupController.GroupEdit,
                //                                                     keyboardType: TextInputType.text,
                //                                                     validator: (value) {
                //                                                       if (value!.isEmpty) {
                //                                                         return "Maydonlar bo'sh bo'lmasligi kerak";
                //                                                       }
                //                                                       return null;
                //                                                     }),
                //                                               ),
                //                                               SizedBox(
                //                                                 height:
                //                                                     16,
                //                                               ),
                //                                             ],
                //                                           ),
                //                                           InkWell(
                //                                             onTap: () {
                //                                               if (_formKey
                //                                                   .currentState!
                //                                                   .validate()) {
                //                                                 groupController.editGroup(groups[
                //                                                         i]
                //                                                     .id
                //                                                     .toString());
                //                                               }
                //                                             },
                //                                             child: Obx(() => CustomButton(
                //                                                 isLoading: groupController
                //                                                     .isLoading
                //                                                     .value,
                //                                                 text:
                //                                                     "Edit")),
                //                                           )
                //                                         ],
                //                                       ),
                //                                     ),
                //                                   ),
                //                                 );
                //                               },
                //                             );
                //                           },
                //                           child: Icon(Icons.edit),
                //                         ),
                //                         SizedBox(
                //                           width: 8,
                //                         ),
                //                         IconButton(
                //                             padding: EdgeInsets.zero,
                //                             onPressed: () {
                //                               showDialog(
                //                                 context: context,
                //                                 builder: (BuildContext
                //                                     context) {
                //                                   return CustomAlertDialog(
                //                                     title: "Delete Group",
                //                                     description:
                //                                         "Are you sure you want to delete this group ?",
                //                                     onConfirm: () async {
                //                                       // Perform delete action here
                //                                       groupController
                //                                           .deleteGroup(
                //                                               groups[i]
                //                                                   .id);
                //                                     },
                //                                     img:
                //                                         'assets/delete.png',
                //                                   );
                //                                 },
                //                               );
                //                             },
                //                             icon: Icon(
                //                               Icons.delete,
                //                               color: Colors.red,
                //                             ))
                //                       ],
                //                     )
                //                   ],
                //                 ),
                //               ),
                //             )
                //         ],
                //       )
                //     : Center(
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Image.asset(
                //               'assets/empty.png',
                //               width: 222,
                //             ),
                //             Text(
                //               'Our center has not any groups ',
                //               style: TextStyle(
                //                   color: Colors.black, fontSize: 33),
                //             ),
                //             SizedBox(
                //               height: 16,
                //             ),
                //           ],
                //         ),
                //       );
              }
              // If no data available

              else {
                return Text('No data'); // No data available
              }
            }),
      ),
    );
  }
}
