
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/input_formatter.dart';
import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../constants/utils.dart';
import '../../../controllers/students/student_controller.dart';

class AdminStudentExam extends StatelessWidget {
  StudentController studentController = Get.put(StudentController());

  final String uniqueId;
  final String id;
  final String name;
  final String surname;
  final bool ?  showButton;

  AdminStudentExam(
      {required this.uniqueId,
        required this.id,
        required this.name,
         this.showButton,
        required this.surname});

  final _formKey = GlobalKey<FormState>();





  String calculateAverage(List exams) {
    dynamic val = 0;
    if(exams.isNotEmpty){

      for(int i = 0 ; i < exams.length ; i++){
        val += int.parse(exams[i]['howMany']) * 100/int.parse(exams[i]['from']);
      }
      val   = val/exams.length;
      return  "O'rtacha: '${val.toString().substring(0,2)} %'";

    }
    return  'Baholanmagan';

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: dashBoardColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: CupertinoColors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          '${name}'.capitalizeFirst! +
              " " +
              "${surname}".capitalizeFirst! +
              " Imtihon tarixi",
          style:
          appBarStyle.copyWith(color: CupertinoColors.white, fontSize: 12),
        ),

      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LeaderStudents')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    height: Get.height,
                    width: Get.width,
                    child: Center(child: CircularProgressIndicator()));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.hasData) {
                List exams = snapshot.data!.docs
                    .where((el) => el['items']['uniqueId'] == uniqueId)
                    .toList();
                return exams[0]['items']['exams'].isNotEmpty
                    ? Column(
                  children: [
                    for (int i = 0;
                    i < exams[0]['items']['exams'].length;
                    i++)
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: Colors.black, width: .5)),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      "Imtihon mavzusi: ",
                                      style: appBarStyle.copyWith(
                                          fontSize: 10,
                                          color:
                                          CupertinoColors.systemGrey),
                                    ),
                                    Text(

                                          "${exams[0]['items']['exams'][i]['title']}",
                                      style: appBarStyle.copyWith(
                                          color: Colors.black,
                                          fontSize: 16),
                                    ),

                                    Text(
                                      "Imtihon o'tkazilgan sana: ",
                                      style: appBarStyle.copyWith(
                                          fontSize: 10,
                                          color:
                                          CupertinoColors.systemGrey),
                                    ),
                                    Text(

                                          "${exams[0]['items']['exams'][i]['examDate']}".substring(0,10) ,
                                      style: appBarStyle.copyWith(
                                          color: Colors.blue,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Foizda: ",
                                      style: appBarStyle.copyWith(
                                          fontSize: 10),
                                    ),
                                    Text(
                                      " ${int.parse(exams[0]['items']['exams'][i]['howMany']) * 100/int.parse(exams[0]['items']['exams'][i]['from'])}".substring(0,5) + "%",
                                      style: appBarStyle.copyWith(
                                          color: Colors.green,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Soni: ",
                                      style: appBarStyle.copyWith(
                                          fontSize: 10),
                                    ),
                                    Text(
                                      "${exams[0]['items']['exams'][i]['howMany']}/${exams[0]['items']['exams'][i]['from']}",
                                      style: appBarStyle.copyWith(
                                          color: Colors.green,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                               ],
                            ),

                          ],
                        ),
                      )
                  ],
                )
                    : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                      ),
                      Image.asset(
                        'assets/exams2.png',
                        width: 222,
                      ),
                      Text(
                        '${name}'.capitalizeFirst! +
                            " " +
                            "${surname}".capitalizeFirst! +
                            " da imtihonlar mavjud emas ",
                        style:
                        TextStyle(color: Colors.black, fontSize: 12),
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
      ),
    );
  }
}
