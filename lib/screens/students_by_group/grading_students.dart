import 'package:leader/screens/students_by_group/students_by_group_grading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/constants/custom_widgets/emptiness.dart';
import '../../controllers/grade_controller/grade_controller.dart';

class GradingStudents extends StatelessWidget {
  final String group;
  final String groupId;

  GradingStudents({required this.group, required this.groupId});

  final _formKey = GlobalKey<FormState>();

  GradeController gradeController = Get.put(GradeController());
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffe8e8e8),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LeaderGrading')
                .where('items.group', isEqualTo: group)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Xatolik: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                var _grades = snapshot.data!.docs;

                _grades.sort((b, a) =>
                    a['items']['uniqueId'].compareTo(b['items']['uniqueId']));

                return _grades.isNotEmpty
                    ? ListView.builder(
                        itemCount: _grades.length,
                        itemBuilder: (context, index) {
                          var grades = _grades[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(Grading(
                                groupId: groupId,
                                groupName: group,
                                 gradeDate: _grades[index]['items']['date'],
                                gradeTime: _grades[index]['items']['time'],
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      index == 0 ? Colors.green : Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              margin: EdgeInsets.all(4),
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "O'chirish",
                                            middleText:
                                                "Rostdanham o'chirilsinmi ?",
                                            textCancel: "Yoq",
                                            textConfirm: "Ha",
                                            confirmTextColor: Colors.white,
                                            onConfirm: () {
                                              gradeController
                                                  .deleteGrade(grades.id);
                                            },
                                            onCancel: () {},
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                                title: Text(
                                  '${grades['items']['date']}  ' +
                                      '  ${grades['items']['time']} ',
                                  style: TextStyle(
                                      color: index == 0
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Emptiness(title: 'Yo\'q');
              }
              // If no data available

              else {
                return Text('Malumot mavjud emas'); // No data available
              }
            }),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          gradeController.addGrading(group);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
