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
