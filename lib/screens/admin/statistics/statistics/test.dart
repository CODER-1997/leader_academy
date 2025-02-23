import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/statistics_controller/statistics_controller.dart';

class TTT extends StatelessWidget {
  final List students;

  TTT({required this.students});

  List _students = [];
  StatisticsController _statisticsController = Get.put(StatisticsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){

          for (int i = 0 ; i < students.length ; i++) {
            var payments = students[i]['items']['payments'];
            var name = students[i]['items']['name'];
             var surname = students[i]['items']['surname'];
             var startedDay = students[i]['items']['startedDay'];
            _students.add({
                'name': name.toString().capitalizeFirst! ,
                'order': '' ,
               'surname':  surname.toString().capitalizeFirst!,
               'payments': payments,
               'startedDay': startedDay
            });
          }



           _statisticsController.createPdfAndNotify(_students, "To'lov haqida malumotlar");


        }, icon: Icon(Icons.picture_as_pdf))],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [

          ],),
        ),
      ),
    );
  }
}
