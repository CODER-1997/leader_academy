import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/controllers/groups/group_controller.dart';

class SelectedSubjectCard extends StatelessWidget {

  final String subject;
  SelectedSubjectCard({required this.subject});
  GroupController groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
      onTap: () {
        groupController.selectedSubject.value =
        "$subject";

      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 18, vertical: 8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color:  groupController.selectedSubject.value ==
                "$subject"
                ? Colors.green
                : Colors.white,
            borderRadius:
            BorderRadius.circular(112),
            border: Border.all(
                color: Colors.green,
                width: 1)),
        child: Text(
          "$subject",
          style: TextStyle(
            color:  groupController.selectedSubject.value ==
                "$subject"
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    ));
  }
}
