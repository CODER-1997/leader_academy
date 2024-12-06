import 'package:leader/constants/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/constants/custom_widgets/student_card.dart';
import 'package:leader/screens/admin/students/student_info.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../constants/custom_widgets/emptiness.dart';
import '../../../../constants/theme.dart';

class PaidStudents extends StatelessWidget {

  final List students ;

  PaidStudents({required this.students});


  String getPaidDate(List list){
    String result = "";

    for(var item in list){
      print("List $item");

      if(isDateInCurrentMonth(item['paidDate'])){
        result = item['paidDate'];
        break;
      }
    }


    return result;

  }

  bool isDateInCurrentMonth(String dateString) {
    // Parse the input date string to a DateTime object
    DateTime inputDate = DateTime.parse(dateString.split('-').reversed.join('-'));

    // Get the current date
    DateTime currentDate = DateTime.now();

    // Return true if the year and month match, otherwise false
    return inputDate.year == currentDate.year && inputDate.month == currentDate.month;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          title: Text("Paid Students",style: TextStyle(
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
                child: students.length != 0
                    ?
                GroupedListView (
                  sort: true,
                  elements: students,
                  groupBy: (element) => getPaidDate(element['items']['payments']),
                   groupSeparatorBuilder: (String value) => Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(
                       value,

                        style:   TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
                     ),
                   ),
                  itemBuilder: (context, dynamic element) => GestureDetector(
                    onTap: () {
                      Get.to(StudentInfo(
                          studentId: element.id));
                    },
                    child: StudentCard(
                      item: element['items'],
                    ),
                  ),
                   floatingHeader: false, // optional
                  order: GroupedListOrder.ASC, // optional
                 )
                    : Emptiness(title: 'Our center has not any free of charged student '),
              ),
            ],
          ),
        ));
  }
}
