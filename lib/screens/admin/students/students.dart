import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/screens/admin/students/student_info.dart';
import 'package:leader/screens/admin/students/super_search.dart';
import 'package:leader/screens/students_by_group/additional_funcs/add_student.dart';
import 'package:leader/screens/students_by_group/additional_funcs/add_student_2.dart';

import '../../../constants/custom_widgets/emptiness.dart';
import '../../../constants/custom_widgets/student_card.dart';
import '../../../constants/theme.dart';
import '../../../controllers/students/student_controller.dart';

class AdminStudents extends StatefulWidget {
  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {
  final _formKey = GlobalKey<FormState>();

  StudentController studentController = Get.put(StudentController());

  RxList students = [].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        backgroundColor: dashBoardColor,
        toolbarHeight: 64,
        actions: [
         AddStudent2()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('LeaderStudents')
                      .where('items.isDeleted', isEqualTo: false)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      students.clear();

                      for (var item in snapshot.data!.docs) {
                        students.add(item);
                      }

                      return students.length != 0
                          ? ListView.builder(
                              itemCount: students.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(StudentInfo(
                                      studentId: students[i].id,
                                      subject: '',
                                    ));
                                  },
                                  child: StudentCard(
                                    item: students[i]['items'],
                                  ),
                                );
                              })
                          : Emptiness(
                              title: 'Our center has not any students ');
                    }
                    // If no data available

                    else {
                      return Text('No data'); // No data available
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(SuperSearch(
            students: students.value,
          ));
        },
        backgroundColor: Colors.white,
        child: FaIcon(FontAwesomeIcons.search),
      ),
    );
  }
}
