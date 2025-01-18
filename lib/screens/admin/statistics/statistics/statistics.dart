import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:leader/screens/admin/statistics/statistics/excel_statistics.dart';
import 'package:leader/screens/admin/statistics/statistics/settings/settings.dart';
import 'package:leader/screens/admin/statistics/statistics/subject_card.dart';
import '../../../../constants/text_styles.dart';
import '../../../../constants/theme.dart';
import '../../../../constants/utils.dart';
import '../../../../controllers/groups/group_controller.dart';
import '../../../../controllers/students/student_controller.dart';

class Statistics extends StatelessWidget {
  num calculateTotalPayments(List students) {
    int value = 0;
    for (int i = 0; i < students.length; i++) {
      var paidMonths = students[i]['items']['payments'];
      for (int j = 0; j < paidMonths.length; j++) {
        if (currentMonth(paidMonths[j]['paidDate'].toString())) {
          value += int.parse(paidMonths[j]['paidSum']);
          if (int.parse(paidMonths[j]['paidSum']) != 0) {}
        }
      }
    }
    return value;
  }

  GroupController groupController = Get.put(GroupController());
  final _formKey = GlobalKey<FormState>();

  StudentController studentController = Get.put(StudentController());
  GetStorage box = GetStorage();
  static List<String> targetMonths = [
    "September",
    "October",
    "November",
    "December",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July"
  ];

  // Initialize the result map with default values

  Map<String, Map<String, int>> result = {};
  Map<String, Map<String, int>> _result_(){
        result = {
      for (var month in targetMonths) month: {"sum": 0, "code": 0}
    };

       return result;

  }

  List generateMassive(List payments) {
    _result_();
    var _result = [];
    // Process the payments
    for (var payment in payments) {
      // Parse the date to extract the month name
      DateTime date = DateFormat("dd-MM-yyyy").parse(payment['paidDate']);
      String monthName = DateFormat("MMMM").format(date);

      // Update the corresponding month in the result
      if (result.containsKey(monthName)) {
        result[monthName] = {
          "sum":int.parse( payment['paidSum']),
          "code": int.parse(payment['paymentCode'])
        };
      }
    }

    for (var entry in result.entries) {

      _result.add(entry.value['sum']);
      _result.add(entry.value['code']);
    }

    return _result;
  }

  List getPaymentInfo(List students) {
    var _students = [];
    for (var item in students) {
      var payments = item['items']['payments'];
      var name = item['items']['name'];

      var surname = item['items']['surname'];
      _students.add({
        'surname': name.toString().capitalizeFirst! + " " + surname.toString().capitalizeFirst!,
         'payments': generateMassive(payments)
      });
    }

    return _students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        backgroundColor: dashBoardColor,
        title: Text(
          "Leader statistics",
          style: appBarStyle.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(LeaderSettings());
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('LeaderStudents')
                  .where("items.isDeleted", isEqualTo: false)
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
                  var list = snapshot.data!.docs;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExcelStatistics(
                        students: getPaymentInfo(list),
                      ),
                      SubjectCard(
                          subject: 'Matematika', img: 'math', students: list),
                      SubjectCard(
                          subject: 'Fizika', img: 'physics', students: list),
                      SubjectCard(
                          subject: 'Ona tili',
                          img: 'mother_lang',
                          students: list),
                      SubjectCard(
                          subject: 'Ingliz tili',
                          img: 'english',
                          students: list),
                      SubjectCard(
                          subject: 'Rus tili', img: 'russian', students: list),
                      SubjectCard(
                          subject: 'Tarix', img: 'history', students: list),
                    ],
                  );
                }
                // If no data available

                else {
                  return Text('No data'); // No data available
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
