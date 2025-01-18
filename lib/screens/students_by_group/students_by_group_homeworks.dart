import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/controllers/students/homework_controller.dart';

import 'package:leader/controllers/groups/group_controller.dart';
import '../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../constants/custom_widgets/gradient_button.dart';
import '../../constants/text_styles.dart';
import '../../constants/utils.dart';
import '../../controllers/students/student_controller.dart';


class HomeWorks extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupDocId;
  final String subject;

  HomeWorks({
    required this.groupId,
    required this.groupName,
    required this.groupDocId,
    required this.subject,
  });

  @override
  State<HomeWorks> createState() => _HomeWorksState();
}

class _HomeWorksState extends State<HomeWorks> {
  GetStorage box = GetStorage();

  RxList students = [].obs;

  HomeWorkController homeWorkController = Get.put(HomeWorkController());

  RxList studentList = [].obs;

  StudentController studentController = Get.put(StudentController());

  RxList list = [].obs;

  RxList attendedStudents = [].obs;

  RxList unattendedStudents = [].obs;

  GroupController groupController = Get.put(GroupController());

  String checkStatusHomeWork(List studyDays, String day, String groupId) {
    String status = 'notChecked';
    int index = 0;
    // Parse the date string into a DateTime object
    bool isChecked = false;
    for (int i = 0; i < studyDays.length; i++) {
      if (studyDays[i]['studyDay'] == day.toString() && studyDays[i]['groupId'] == groupId) {
        isChecked = true;
        index = i;
        break;
      }
    }

    if (isChecked == false) {
      return status = "notChecked";
    } else {
      if (studyDays[index]['studyDay'] == day.toString() &&
          studyDays[index]['isDone'] == true &&
          studyDays[index]['groupId'] == groupId &&
          studyDays[index]['hasReason']['commentary'] == "" &&
          studyDays[index]['hasReason']['hasReason'] == false) {
        status = 'true';
      } else {
        status = 'false';
      }
    }
    return status;
  }

  String getReasonHomeWork(List list, String day,String groupId) {
    var result = "";
    var holat = false;
    var index = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i]['studyDay'] == day && list[i]['groupId'] == groupId) {
        holat = true;
        index = i;
        break;
      }
    }

    if (holat) {
      result = list[index]['hasReason']['commentary'];
    }

    return result;
  }

  String _searchText = '';

  final _formKey = GlobalKey<FormState>();
  bool isStudentInGroup(String groupId, List groups){
    bool inGroup = false;

    for(var item in groups){
      if(item['groupId'] == groupId){
        inGroup = true ;
        break;
      }
    }


    return inGroup;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Form(
                key: _formKey,
                child: TextField(
                  decoration: buildInputDecoratione('Qidirish'),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value.toLowerCase();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
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
                    var list = snapshot.data!.docs;
                    students.clear();


                    for (int i = 0; i < list.length; i++) {
                      if (isStudentInGroup( widget.groupId , list[i]['items']['groups'] .toList()) && list[i]['items']['isDeleted'] == false) {
                        students.add({
                          'name': list[i]['items']['name'],
                          'id': list[i].id,
                          'surname': list[i]['items']['surname'],
                           'homeWorks': list[i]['items']['homeWorks'],
                          'uniqueId': list[i]['items']['uniqueId'],
                        });
                      }
                    }
                    students.sort((a, b) => (a['surname'] ).compareTo(b['surname'] ));

                    return students.length != 0
                        ? Obx(() => Column(
                              children: [
                                for (int i = 0; i < students.length; i++)
                                  Container(
                                    margin: EdgeInsets.only(bottom: 1),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: CupertinoColors.white),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              child: Container(
                                                child: Text(
                                                  "${i + 1}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                width: 25,
                                                height: 25,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: Get.width / 2.5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        students[i]['surname']
                                                                .toString()
                                                                .capitalizeFirst! +
                                                            " " +
                                                            students[i]
                                                                    ['name']
                                                                .toString()
                                                                .capitalizeFirst!,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      students[i]['phone']
                                                              .toString()
                                                              .isEmpty
                                                          ? Text(
                                                              "Phone number is empty",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                          : SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            getReasonHomeWork(
                                                        students[i]
                                                            ['homeWorks'],
                                                        studentController
                                                            .selectedStudyDate
                                                            .value,
                                                        widget.groupId)
                                                    .isNotEmpty
                                                ? Container(
                                                    width: Get.width / 6,
                                                    alignment: Alignment.center,
                                                    margin: EdgeInsets.only(
                                                        right: 4, top: 8),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(122),
                                                        border: Border.all(
                                                            color: Colors.red,
                                                            width: 2)),
                                                    child: Text(
                                                      "${getReasonHomeWork(students[i]['homeWorks'], studentController.selectedStudyDate.value, widget.groupId)}",
                                                      style:
                                                          appBarStyle.copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 8,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            InkWell(
                                              onTap: () {
                                                if (checkStatusHomeWork(
                                                        students[i]
                                                            ['homeWorks'],
                                                        studentController
                                                            .selectedStudyDate
                                                            .value,
                                                        widget.groupId) ==
                                                    'true') {
                                                  homeWorkController
                                                      .removeHomeWork(
                                                          students[i]['id'],
                                                          widget.groupId,
                                                          students[i]
                                                              ['uniqueId'],
                                                          {
                                                            'hasReason': false,
                                                            'commentary': "",
                                                          },
                                                          true);
                                                } else {
                                                  homeWorkController
                                                      .setHomework(
                                                          students[i]['id'],
                                                          widget.groupId,
                                                          students[i]
                                                              ['uniqueId'],
                                                          {
                                                            'hasReason': false,
                                                            'commentary': "",
                                                          },
                                                          true,widget.subject);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.green.withOpacity(checkStatusHomeWork(
                                                                    students[i][
                                                                        'homeWorks'],
                                                                    studentController
                                                                        .selectedStudyDate
                                                                        .value,
                                                                    widget.groupId) !=
                                                                'true' ||
                                                            checkStatusHomeWork(
                                                                    students[i][
                                                                        'homeWorks'],
                                                                    studentController
                                                                        .selectedStudyDate
                                                                        .value,
                                                                    widget.groupId) ==
                                                                'notGiven'
                                                        ? .3
                                                        : 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 16),
                                                child: Icon(
                                                  Icons.done_all_outlined,
                                                  size: 18,
                                                  color: checkStatusHomeWork(
                                                                  students[i][
                                                                      'homeWorks'],
                                                                  studentController
                                                                      .selectedStudyDate
                                                                      .value,
                                                                  widget.groupId) !=
                                                              'true' ||
                                                          checkStatusHomeWork(
                                                                  students[i][
                                                                      'homeWorks'],
                                                                  studentController
                                                                      .selectedStudyDate
                                                                      .value,
                                                                  widget.groupId) ==
                                                              'notGiven'
                                                      ? Colors.green
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (checkStatusHomeWork(
                                                        students[i]
                                                            ['homeWorks'],
                                                        studentController
                                                            .selectedStudyDate
                                                            .value,
                                                        widget.groupId) ==
                                                    'false') {
                                                  homeWorkController
                                                      .removeHomeWork(
                                                          students[i]['id'],
                                                          widget.groupId,
                                                          students[i]
                                                              ['uniqueId'],
                                                          {
                                                            'hasReason': false,
                                                            'commentary': "",
                                                          },
                                                          true);
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0)),
                                                        //this right here
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12)),
                                                          width: Get.width - 64,
                                                          height:
                                                              Get.height / 4,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(""),
                                                               Obx(() => Row(
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          homeWorkController
                                                                              .selectedAbsenseReason
                                                                              .value = "Chala";
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              color: homeWorkController.selectedAbsenseReason.value == "Chala" ? Colors.red : Colors.white,
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              border: Border.all(color: Colors.black)),
                                                                          child:
                                                                              Text(
                                                                            "Chala",
                                                                            style:
                                                                                TextStyle(
                                                                              color: homeWorkController.selectedAbsenseReason.value == "Chala" ? Colors.white : Colors.black,
                                                                            ),
                                                                          ),
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          homeWorkController
                                                                              .selectedAbsenseReason
                                                                              .value = "Qilinmagan";
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              color: homeWorkController.selectedAbsenseReason.value == "Qilinmagan" ? Colors.red : Colors.white,
                                                                              borderRadius: BorderRadius.circular(12),
                                                                              border: Border.all(color: Colors.black)),
                                                                          child:
                                                                              Text(
                                                                            "Qilinmagan",
                                                                            style:
                                                                                TextStyle(
                                                                              color: homeWorkController.selectedAbsenseReason.value == "Qilinmagan" ? Colors.white : Colors.black,
                                                                            ),
                                                                          ),
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              InkWell(
                                                                onTap: () {
                                                                  if (homeWorkController
                                                                          .reasonOfBeingAbsent
                                                                          .text
                                                                          .isEmpty &&
                                                                      homeWorkController
                                                                          .selectedAbsenseReason
                                                                          .value
                                                                          .isEmpty) {
                                                                    Get.back();
                                                                  } else {
                                                                    homeWorkController.setHomework(
                                                                        students[i]['id'],
                                                                        widget.groupId,
                                                                        students[i]['uniqueId'],
                                                                        {
                                                                          'hasReason': homeWorkController.selectedAbsenseReason.value == "Chala"
                                                                              ? true
                                                                              : false,
                                                                          'commentary': homeWorkController.reasonOfBeingAbsent.text.isEmpty
                                                                              ? homeWorkController.selectedAbsenseReason.value
                                                                              : homeWorkController.reasonOfBeingAbsent.text,
                                                                        },
                                                                        false,widget.subject);

                                                                    Get.back();
                                                                  }
                                                                },
                                                                child: Obx(() => CustomButton(
                                                                    color: Colors
                                                                        .red,
                                                                    isLoading: homeWorkController
                                                                        .isLoading
                                                                        .value,
                                                                    text: 'Tasdiqlash'
                                                                        .tr
                                                                        .capitalizeFirst!)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.red.withOpacity(checkStatusHomeWork(
                                                                    students[i][
                                                                        'homeWorks'],
                                                                    studentController
                                                                        .selectedStudyDate
                                                                        .value,
                                                                    widget.groupId) ==
                                                                'notChecked' ||
                                                            checkStatusHomeWork(
                                                                    students[i][
                                                                        'homeWorks'],
                                                                    studentController
                                                                        .selectedStudyDate
                                                                        .value,
                                                                    widget.groupId) ==
                                                                'true'
                                                        ? .3
                                                        : 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 16),
                                                child: Icon(
                                                    Icons.remove_done_sharp,
                                                    size: 18,
                                                    color: checkStatusHomeWork(
                                                                    students[i][
                                                                        'homeWorks'],
                                                                    studentController
                                                                        .selectedStudyDate
                                                                        .value,
                                                                    widget.groupId) ==
                                                                'notChecked' ||
                                                            checkStatusHomeWork(
                                                                    students[i][
                                                                        'homeWorks'],
                                                                    studentController
                                                                        .selectedStudyDate
                                                                        .value,
                                                                    widget.groupId) ==
                                                                'true'
                                                        ? Colors.red
                                                        : Colors.white),
                                              ),
                                            ),

                                            // TextButton(
                                            //   onPressed: () {
                                            //     homeWorkController
                                            //         .setStudyDay(
                                            //             students[i].id,
                                            //             groupId,
                                            //             students[i]
                                            //
                                            //                 ['uniqueId'],
                                            //             {
                                            //           'hasReason': false,
                                            //           'commentary': ""
                                            //         });
                                            //   },
                                            //   child: Text(
                                            //     checkStatusHomeWork(
                                            //       students[i]['items']
                                            //           ['homeWorks'],
                                            //     )
                                            //         ? 'Present'
                                            //         : "Absent",
                                            //     style: TextStyle(
                                            //         fontSize: 12,
                                            //         fontWeight:
                                            //             FontWeight.w900,
                                            //         color: checkStatus(
                                            //           students[i]['items']
                                            //               ['homeWorks'],
                                            //         )
                                            //             ? greenColor
                                            //             : Colors.red),
                                            //   ),
                                            // ),

                                            // Visibility(
                                            //   visible: hasDebt(students[i]['items']
                                            //   ['payments']),
                                            //   child: Container(
                                            //     padding: EdgeInsets.all(16),
                                            //     decoration: BoxDecoration(
                                            //         color: Colors.red,
                                            //         border: Border.all(color: Colors.red,width: 1),
                                            //         borderRadius: BorderRadius.circular(102)
                                            //     ),
                                            //     child: Text("Fee unpaid",style: appBarStyle.copyWith(color: Colors.white,fontSize: 16),),
                                            //   ),
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ))
                        : Container(
                            alignment: Alignment.center,
                            height: Get.height * .8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/empty.png',
                                  width: 150,
                                ),
                                Text(
                                  'This group has not any students ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
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
      // bottomNavigationBar: Container(
      //   height: 66,
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       children: [
      //         Expanded(
      //             child: InkWell(
      //           onTap: () async {
      //             if (selectedStudents.isEmpty) {
      //               Get.snackbar(
      //                 'Error', // Title
      //                 'Students are not selected', // Message
      //                 snackPosition: SnackPosition.TOP,
      //                 // Position of the snackbar
      //                 backgroundColor: Colors.red,
      //                 colorText: Colors.white,
      //                 borderRadius: 8,
      //                 margin: EdgeInsets.all(10),
      //               );
      //             } else {
      //               showDialog(
      //                 context: context,
      //                 builder: (BuildContext context) {
      //                   return Dialog(
      //                     backgroundColor: Colors.white,
      //                     insetPadding: EdgeInsets.symmetric(horizontal: 16),
      //                     shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(12.0)),
      //                     //this right here
      //                     child: Container(
      //                       padding: EdgeInsets.all(16),
      //                       decoration: BoxDecoration(
      //                           color: Colors.white,
      //                           borderRadius: BorderRadius.circular(12)),
      //                       width: Get.width,
      //                       height: 180,
      //                       child: Column(
      //                         crossAxisAlignment: CrossAxisAlignment.center,
      //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                         children: [
      //                           Column(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             crossAxisAlignment: CrossAxisAlignment.center,
      //                             children: [
      //                               SizedBox(
      //                                 height: 16,
      //                               ),
      //                               Text(
      //                                 'Do you want to really send sms to numbers',
      //                                 style: appBarStyle.copyWith(),
      //                                 textAlign: TextAlign.center,
      //                               ),
      //                               SizedBox(
      //                                 height: 16,
      //                               ),
      //                             ],
      //                           ),
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceEvenly,
      //                             children: [
      //                               TextButton(
      //                                 onPressed: () async {
      //                                   groupController.setSmsDate(groupDocId);
      //
      //                                   Get.back();
      //                                   messageLoader.value = true;
      //                                   for (int i = 0;
      //                                       i < selectedStudents.length;
      //                                       i++) {
      //                                     if (checkStatus(
      //                                             selectedStudents[i]
      //                                                 ['homeWorks'],
      //                                             homeWorkController
      //                                                 .selectedStudyDate
      //                                                 .value,groupId) ==
      //                                         'true') {
      //                                       if (await Permission
      //                                               .sms.isGranted &&
      //                                           selectedStudents[i]['phone']
      //                                               .toString()
      //                                               .isNotEmpty) {
      //                                         _smsService.sendSMS(
      //                                             selectedStudents[i]['phone'],
      //                                             "Assalomu Aleykum ,"
      //                                             "\nFarzandingiz ${selectedStudents[i]['surname'].toString().capitalizeFirst}  ${selectedStudents[i]['name'].toString().capitalizeFirst!}  bugungi ingliz tili  darsiga keldi. "
      //                                             "\nHurmat bilan Leader Acadey");
      //                                       }
      //                                     } else if (checkStatus(
      //                                             selectedStudents[i]
      //                                                 ['homeWorks'],
      //                                             homeWorkController
      //                                                 .selectedStudyDate
      //                                                 .value,groupId) ==
      //                                         'false') {
      //                                       if (await Permission
      //                                               .sms.isGranted &&
      //                                           selectedStudents[i]['phone']
      //                                               .toString()
      //                                               .isNotEmpty) {
      //                                         var sabab = hasReason(
      //                                                 selectedStudents[i]
      //                                                     ['homeWorks'],
      //                                                 homeWorkController
      //                                                     .selectedStudyDate
      //                                                     .value)
      //                                             ? "sababli"
      //                                             : "sababsiz";
      //
      //                                         _smsService.sendSMS(
      //                                             selectedStudents[i]['phone'],
      //                                             ""
      //                                             "Assalomu Aleykum ,"
      //                                             "\nFarzandingiz ${selectedStudents[i]['surname'].toString().capitalizeFirst!}  ${selectedStudents[i]['name'].toString().capitalizeFirst!}  bugungi ingliz tili  darsiga $sabab kelmadi. "
      //                                             "\nHurmat bilan Leader Acadey");
      //                                       }
      //                                     } else {
      //                                       print('Sms yuborilmadi');
      //                                     }
      //                                     await Future.delayed(
      //                                         Duration(seconds: 1));
      //                                   }
      //
      //                                   messageLoader.value = false;
      //                                   selectedStudents.clear();
      //                                   isStudentChoosen.value = false;
      //
      //                                   Get.snackbar(
      //                                     'Message', // Title
      //                                     'Your message has been sent',
      //                                     // Message
      //                                     snackPosition: SnackPosition.BOTTOM,
      //                                     // Position of the snackbar
      //                                     backgroundColor: Colors.green,
      //                                     colorText: Colors.white,
      //                                     borderRadius: 8,
      //                                     margin: EdgeInsets.all(10),
      //                                   );
      //                                 },
      //                                 child: Text(
      //                                   'Confirm'.tr.capitalizeFirst!,
      //                                   style: appBarStyle.copyWith(
      //                                       color: Colors.green),
      //                                 ),
      //                               ),
      //                               TextButton(
      //                                   onPressed: Get.back,
      //                                   child: Text(
      //                                     'Cancel',
      //                                     style: appBarStyle.copyWith(
      //                                         color: Colors.red),
      //                                   )),
      //                             ],
      //                           )
      //                         ],
      //                       ),
      //                     ),
      //                   );
      //                 },
      //               );
      //             }
      //           },
      //           child: Obx(() => CustomButton(
      //                 color: Colors.green,
      //                 text: messageLoader.value
      //                     ? "Sending ..."
      //                     : 'attendance'.tr.capitalizeFirst!,
      //               )),
      //         )),
      //         box.read('isLogged') == '0094'
      //             ? Expanded(
      //                 child: InkWell(
      //                 onTap: () async {
      //                   if (selectedStudents.isEmpty) {
      //                     Get.snackbar(
      //                       'Error', // Title
      //                       'Students are not selected', // Message
      //                       snackPosition: SnackPosition.TOP,
      //                       // Position of the snackbar
      //                       backgroundColor: Colors.red,
      //                       colorText: Colors.white,
      //                       borderRadius: 8,
      //                       margin: EdgeInsets.all(10),
      //                     );
      //                   } else {
      //                     showDialog(
      //                       context: context,
      //                       builder: (BuildContext context) {
      //                         return Dialog(
      //                           backgroundColor: Colors.white,
      //                           insetPadding:
      //                               EdgeInsets.symmetric(horizontal: 16),
      //                           shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(12.0)),
      //                           //this right here
      //                           child: Container(
      //                             padding: EdgeInsets.all(16),
      //                             decoration: BoxDecoration(
      //                                 color: Colors.white,
      //                                 borderRadius: BorderRadius.circular(12)),
      //                             width: Get.width,
      //                             height: 180,
      //                             child: Column(
      //                               crossAxisAlignment:
      //                                   CrossAxisAlignment.center,
      //                               mainAxisAlignment:
      //                                   MainAxisAlignment.spaceBetween,
      //                               children: [
      //                                 Column(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.center,
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.center,
      //                                   children: [
      //                                     SizedBox(
      //                                       height: 16,
      //                                     ),
      //                                     Text(
      //                                       'Do you want to really send sms to numbers',
      //                                       style: appBarStyle.copyWith(),
      //                                       textAlign: TextAlign.center,
      //                                     ),
      //                                     SizedBox(
      //                                       height: 16,
      //                                     ),
      //                                   ],
      //                                 ),
      //                                 Row(
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.spaceEvenly,
      //                                   children: [
      //                                     TextButton(
      //                                       onPressed: () async {
      //                                         Get.back();
      //                                         messageLoader2.value = true;
      //
      //                                         for (int i = 0;
      //                                             i < selectedStudents.length;
      //                                             i++) {
      //                                           if (selectedStudents[i][
      //                                                       'isFreeOfcharge'] ==
      //                                                   false &&
      //                                               hasDebtFromMonth(
      //
      //
      //
      //
      //                                                   selectedStudents[i]
      //                                                       ['payments'],
      //                                                   convertDateToMonthYear(
      //                                                       homeWorkController
      //                                                           .selectedStudyDate
      //                                                           .value))) {
      //                                             if (await Permission
      //                                                     .sms.isGranted &&
      //                                                 selectedStudents[i]
      //                                                         ['phone']
      //                                                     .toString()
      //                                                     .isNotEmpty) {
      //                                               _smsService.sendSMS(
      //                                                   selectedStudents[i]
      //                                                       ['phone'],
      //                                                   "Hurmatli ota-ona, "
      //                                                   "\nFarzandingiz ${selectedStudents[i]['surname'].toString().capitalizeFirst} ${selectedStudents[i]['name'].toString().capitalizeFirst!}ning ${getCurrentMonthInUzbek()} oylari uchun to'lovi oyning 5-sanasiga qadar to'lanishi kerak.");
      //
      //                                               _smsService.sendSMS(
      //                                                   selectedStudents[i]
      //                                                       ['phone'],
      //                                                   " Iltimos, to'lovni belgilangan muddatda amalga oshirishingizni so'raymiz.\nHurmat bilan Leader Acadey");
      //                                             }
      //                                           }
      //                                         }
      //
      //                                         messageLoader2.value = false;
      //                                         selectedStudents.clear();
      //                                         isStudentChoosen.value = false;
      //
      //                                         Get.snackbar(
      //                                           'Message', // Title
      //                                           'Your message has been sent',
      //                                           // Message
      //                                           snackPosition:
      //                                               SnackPosition.BOTTOM,
      //                                           // Position of the snackbar
      //                                           backgroundColor: Colors.green,
      //                                           colorText: Colors.white,
      //                                           borderRadius: 8,
      //                                           margin: EdgeInsets.all(10),
      //                                         );
      //                                       },
      //                                       child: Text(
      //                                         'Confirm'.tr.capitalizeFirst!,
      //                                         style: appBarStyle.copyWith(
      //                                             color: Colors.green),
      //                                       ),
      //                                     ),
      //                                     TextButton(
      //                                         onPressed: Get.back,
      //                                         child: Text(
      //                                           'Cancel',
      //                                           style: appBarStyle.copyWith(
      //                                               color: Colors.red),
      //                                         )),
      //                                   ],
      //                                 )
      //                               ],
      //                             ),
      //                           ),
      //                         );
      //                       },
      //                     );
      //                   }
      //                 },
      //                 child: Obx(() => Container(
      //                       margin: EdgeInsets.only(left: 4),
      //                       child: CustomButton(
      //                         color: Colors.red,
      //                         text: messageLoader2.value
      //                             ? "Sending..."
      //                             : 'Payment',
      //                       ),
      //                     )),
      //               ))
      //             : SizedBox(),
      //         box.read('isLogged') == '0094'
      //             ? Expanded(
      //                 child: InkWell(
      //                 onTap: () async {
      //                   if (selectedStudents.isEmpty) {
      //                     Get.snackbar(
      //                       'Error', // Title
      //                       'Students are not selected', // Message
      //                       snackPosition: SnackPosition.TOP,
      //                       // Position of the snackbar
      //                       backgroundColor: Colors.red,
      //                       colorText: Colors.white,
      //                       borderRadius: 8,
      //                       margin: EdgeInsets.all(10),
      //                     );
      //                   } else {
      //                     showDialog(
      //                       context: context,
      //                       builder: (BuildContext context) {
      //                         return Dialog(
      //                           backgroundColor: Colors.white,
      //                           insetPadding:
      //                               EdgeInsets.symmetric(horizontal: 16),
      //                           shape: RoundedRectangleBorder(
      //                               borderRadius: BorderRadius.circular(12.0)),
      //                           //this right here
      //                           child: Form(
      //                             key: _formKey,
      //                             child: Container(
      //                               padding: EdgeInsets.all(16),
      //                               decoration: BoxDecoration(
      //                                   color: Colors.white,
      //                                   borderRadius:
      //                                       BorderRadius.circular(12)),
      //                               width: Get.width,
      //                               height: Get.height / 2.5,
      //                               child: Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 mainAxisAlignment:
      //                                     MainAxisAlignment.spaceBetween,
      //                                 children: [
      //                                   Column(
      //                                     children: [
      //                                       SizedBox(
      //                                         height: 16,
      //                                       ),
      //                                       TextFormField(
      //                                         maxLines: 5,
      //                                         controller: customMessage,
      //                                         maxLength: 80,
      //                                         keyboardType: TextInputType.text,
      //                                         decoration: buildInputDecoratione(
      //                                             'Your message here'
      //                                                     .tr
      //                                                     .capitalizeFirst! ??
      //                                                 ''),
      //                                       ),
      //                                       SizedBox(
      //                                         height: 16,
      //                                       ),
      //                                     ],
      //                                   ),
      //                                   InkWell(
      //                                     onTap: () async {
      //                                       messageLoader3.value = true;
      //                                       if (customMessage.text.isNotEmpty) {
      //                                         for (int i = 0;
      //                                             i < selectedStudents.length;
      //                                             i++) {
      //                                           if (await Permission
      //                                                   .sms.isGranted &&
      //                                               selectedStudents[i]['phone']
      //                                                   .toString()
      //                                                   .isNotEmpty) {
      //                                             _smsService.sendSMS(
      //                                                 selectedStudents[i]
      //                                                     ['phone'],
      //                                                 customMessage.text +
      //                                                     "\nHurmat bilan Leader Acadey");
      //                                           }
      //
      //                                           await Future.delayed(
      //                                               Duration(seconds: 1));
      //                                         }
      //                                         messageLoader3.value = false;
      //                                         customMessage.clear();
      //                                         selectedStudents.clear();
      //                                         isStudentChoosen.value = false;
      //
      //                                         Get.back();
      //
      //                                         Get.snackbar(
      //                                           'Message', // Title
      //                                           'Your message has been sent',
      //                                           // Message
      //                                           snackPosition:
      //                                               SnackPosition.BOTTOM,
      //                                           // Position of the snackbar
      //                                           backgroundColor: Colors.blue,
      //                                           colorText: Colors.white,
      //                                           borderRadius: 8,
      //                                           margin: EdgeInsets.all(10),
      //                                         );
      //                                       } else {
      //                                         Get.back();
      //                                       }
      //                                     },
      //                                     child: Obx(() => CustomButton(
      //                                         isLoading: homeWorkController
      //                                             .isLoading.value,
      //                                         text: messageLoader3.value
      //                                             ? "Sending. . ."
      //                                             : "Send"
      //                                                 .tr
      //                                                 .capitalizeFirst!)),
      //                                   )
      //                                 ],
      //                               ),
      //                             ),
      //                           ),
      //                         );
      //                       },
      //                     );
      //                   }
      //                 },
      //                 child: Container(
      //                   margin: EdgeInsets.only(left: 4),
      //                   child: CustomButton(
      //                     color: Colors.blue,
      //                     text: 'Custom',
      //                   ),
      //                 ),
      //               ))
      //             : SizedBox(),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
