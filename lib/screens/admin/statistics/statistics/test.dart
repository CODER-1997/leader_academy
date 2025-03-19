import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leader/constants/custom_widgets/gradient_button.dart';

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

      ),
      body: Obx(()=> StatisticsController.loader.value   ? Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color:  Colors.green,),
          SizedBox(height: 16,),
          Text('Malumotlarni tayyaorlayapmiz . \n ozroq sabr',textAlign: TextAlign.center,style:TextStyle(
            fontSize: 16,fontWeight: FontWeight.w800
          ),),
        ],
      ),) :  Container(
        child: Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(

              onTap: (){
                for (int i = 0 ; i < students.length ; i++) {
                  var payments = students[i]['items']['payments'];
                  var name = students[i]['items']['name'];
                  var surname = students[i]['items']['surname'];
                  var startedDay = students[i]['items']['startedDay'];
                  var studyDays = students[i]['items']['studyDays'];
                  _students.add({
                    'name': name.toString().capitalizeFirst! ,
                    'order': '' ,
                    'surname':  surname.toString().capitalizeFirst!,
                    'payments': payments,
                    'startedDay': startedDay,
                    'studyDays':studyDays
                  });
                }



                _statisticsController.createPdfAndNotify(_students, "To'lov haqida malumotlar");
              },
              child: CustomButton(text: 'Hisobotni olish',color: Colors.green,)),
        ),),
      )),
    );
  }
}
