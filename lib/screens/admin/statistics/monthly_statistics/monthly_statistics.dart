import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/constants/text_styles.dart';
import 'package:leader/constants/theme.dart';
import 'package:leader/constants/utils.dart';
import 'package:leader/screens/admin/statistics/monthly_statistics/month_statistic.dart';

class MonthlyStatistics extends StatelessWidget {


  List CalculateUnpaidStudents(String month,List students) {
    List unpaidStudents = [];
    for (int i = 0; i < students.length; i++) {
      if (hasDebtFromMonth(students[i]['items']['payments'], month)) {
        unpaidStudents.add(students[i]);
      }
    }

    return unpaidStudents;
  }
  List CalculatepaidStudents(String month,List students) {
    List paidStudents = [];
    for (int i = 0; i < students.length; i++) {
      if (hasDebtFromMonth(students[i]['items']['payments'], month) == false) {
        paidStudents.add(students[i]);
      }
    }

    return paidStudents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        title: Text(
          'Monthly statistics',
          style: appBarStyle,
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('LeaderStudents').
            where('items.isDeleted',isEqualTo: false)
            .where('items.isFreeOfcharge',isEqualTo: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {

                return Center(child: Text('Error: ${snapshot.error}'));

              }
              // If data is available
              if (snapshot.hasData) {
                var students = snapshot.data!.docs;


                return Column(children: [

                for(int i = 0 ; i < generateMonthsList().length;i++)
                  InkWell(
                    onTap:(){
                     Get.to(MonthStatistics(
                       title: generateMonthsList()[i],
                       unpaidStudents: CalculateUnpaidStudents(generateMonthsList()[i],students),
                        paidStudents: CalculatepaidStudents(generateMonthsList()[i],students),));
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            generateMonthsList()[i],
                            style: appBarStyle.copyWith(fontSize: 16),
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(4),
                              width: 33,
                              height: 33,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(112)
                              ),
                              child: Text(
                                "${CalculateUnpaidStudents(generateMonthsList()[i],students).length}",
                                style: appBarStyle.copyWith(fontSize: 12, color: Colors.white),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],);
                // return  ListView.builder(
                //   itemCount:snapshot.data!.docs.length,
                //   itemBuilder: (BuildContext context, int index) {
                //     var element = snapshot.data!.docs
                //     [index]['items'];
                //
                //   },
                // );
              }
              // If no data available

              else {
                return Text('No data'); // No data available
              }
            },
          ),





        ],
      ),
    );
  }
}
