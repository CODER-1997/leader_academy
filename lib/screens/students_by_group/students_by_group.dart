import 'package:leader/screens/students_by_group/grading_students.dart';
import 'package:leader/screens/students_by_group/students_by_group_attendance.dart';
import 'package:leader/screens/students_by_group/students_by_group_grading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/screens/students_by_group/students_by_group_homeworks.dart';
import 'package:lottie/lottie.dart';

import '../../constants/text_styles.dart';
import '../../constants/theme.dart';
import '../../controllers/students/student_controller.dart';
import 'additional_funcs/add_student.dart';
import 'exams.dart';

class StudentsByGroup extends StatefulWidget {
  final String groupId;
  final String groupDocId;
  final String groupName;
  final String subject;

  StudentsByGroup({
    required this.groupId,
    required this.subject,
    required this.groupName,
    required this.groupDocId,
  });

  @override
  State<StudentsByGroup> createState() => _StudentsByGroupState();
}

class _StudentsByGroupState extends State<StudentsByGroup>
    with SingleTickerProviderStateMixin {
  StudentController studentController = Get.put(StudentController());

  late TabController _tabController;

  GetStorage box = GetStorage();

  RxList students = [].obs;

  RxList studentList = [].obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Obx(
                () => Text(
                  "${studentController.selectedStudyDate.value}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              InkWell(
                  onTap: () {
                    studentController
                        .showDate2(studentController.selectedStudyDate);
                  },
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  )),
              SizedBox(
                width: 16,
              ),
              AddStudent(
                groupName: widget.groupName,
                groupId: widget.groupId,
                subject: widget.subject,
              ),
              SizedBox(
                width: 8,
              )
            ],
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: dashBoardColor,
        toolbarHeight: 64,
        title: Text(
          "${widget.groupName} ",
          style: appBarStyle.copyWith(color: Colors.white, fontSize: 14),
        ),
        bottom: TabBar(
          padding: EdgeInsets.zero,
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Container(
                alignment: Alignment.center,
                width: Get.width / 2,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Davomat',
                  style: TextStyle(color: Colors.white),
                )),
            Text(
              'Vazifalar',
              style: TextStyle(color: Colors.white),
            ),
            Container(
                alignment: Alignment.center,
                width: Get.width / 2,
                height: 50,
                decoration: BoxDecoration(),
                child: Text(
                  'Imtihonlar',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      ),
      body: Obx(() => Attendance.messageLoader.value
          ? Container(
              height: Get.height,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: Get.height / 12,
                    ),
                    Lottie.asset('assets/lottie/mail_sending.json'),
                    Text(
                      'Smslar yuborilyapti , ozroq kuting...',
                      style: appBarStyle.copyWith(fontSize: 16),
                    ),
                    SizedBox(
                      height: Get.height / 3,
                    )
                  ],
                ),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                Attendance(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  groupDocId: widget.groupDocId,
                  subject: widget.subject,
                ),
                HomeWorks(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  groupDocId: widget.groupDocId,
                  subject: widget.subject,
                ),
                Exams(
                  groupId: widget.groupId,
                  group: widget.groupName,
                  subject: widget.subject,

                ),
              ],
            )),
    );
  }
}
