import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/controllers/statistics_controller/statistics_controller.dart';
 import 'package:get/get.dart';
import 'package:leader/screens/admin/statistics/statistics/test.dart';

class ExcelStatistics extends StatelessWidget {
  final List students;

  ExcelStatistics({required this.students});

  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return box.read("isLogged") == "004422"
        ? InkWell(
            onTap: () async {
              Get.to(TTT(students: students));
            },
            child: Container(
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text("To'lovlarni excelda olish"),
                )),
          )
        : SizedBox();
  }
}
