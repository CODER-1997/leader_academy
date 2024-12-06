import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/constants/custom_widgets/student_card.dart';
import 'package:leader/screens/admin/students/student_info.dart';

import '../../../../constants/custom_widgets/emptiness.dart';
import '../../../../constants/theme.dart';

class FreeOfChargeds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          title: Text("Free of charged students",style: TextStyle(
            color: Colors.white
          ),),
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          leading: IconButton(
            onPressed: Get.back,
            icon: Icon(Icons.arrow_back,color: Colors.white,),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 4),
              Expanded(
                child: StreamBuilder(
                    stream:FirebaseFirestore.instance
                        .collection('LeaderStudents')
                        .where('items.isDeleted', isEqualTo: false)
                        .where('items.isFreeOfcharge', isEqualTo: true)
                        .snapshots()
                     ,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.hasData) {
                        var students = snapshot.data!.docs;

                        return students.length != 0
                            ? ListView.builder(
                            itemCount: students.length,
                            itemBuilder: (context, i) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(StudentInfo(
                                      studentId: students[i].id));
                                },
                                child: StudentCard(
                                  item: students[i]['items'],
                                ),
                              );
                            })
                            : Emptiness(title: 'Our center has not any free of charged student ');
                      }
                      // If no data available

                      else {
                        return Text('No data'); // No data available
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
