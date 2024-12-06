import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/controllers/students/student_controller.dart';

import '../text_styles.dart';
import '../utils.dart';
import 'FormFieldDecorator.dart';
import 'custom_dialog.dart';
import 'gradient_button.dart';

class StudentCard extends StatelessWidget {
  final Map item;
  final bool? isFeePaid;

  StudentCard({required this.item, this.isFeePaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: CupertinoColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: Get.width * .35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'].toString().capitalizeFirst! +
                              " " +
                              item['surname'].toString().capitalizeFirst!,
                          overflow: TextOverflow.ellipsis,
                        ),
                        item['group'].toString().isNotEmpty
                            ? Text(
                                item['group'].toString().capitalizeFirst!,
                                style: TextStyle(fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                "Group not defined".toString().capitalizeFirst!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                                overflow: TextOverflow.ellipsis,
                              ),
                        item['phone'].toString().isNotEmpty
                            ? SizedBox()
                            : Text(
                                "Phone is not defined"
                                    .toString()
                                    .capitalizeFirst!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.red),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  // show status has debt
                  SizedBox(
                    width: 4,
                  ),
                  isFeePaid == null
                      ? (item['isFreeOfcharge'] != true
                          ? (hasDebt(item['payments'])
                              ? Container(
                                  width: 66,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(102)),
                                  child: Text(
                                    "Fee unpaid",
                                    style: appBarStyle.copyWith(
                                        color: Colors.white, fontSize: 8),
                                  ),
                                  alignment: Alignment.center,
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  width: 66,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(
                                          color: Colors.green, width: 1),
                                      borderRadius: BorderRadius.circular(102)),
                                  child: Text(
                                    "Paid",
                                    style: appBarStyle.copyWith(
                                        color: Colors.white, fontSize: 8),
                                  ),
                                ))
                          : Image.asset(
                              'assets/verified.png',
                              width: 22,
                            ))
                      : Container(
                          child: isFeePaid == false
                              ? Container(
                                  width: 66,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(102)),
                                  child: Text(
                                    "Fee unpaid",
                                    style: appBarStyle.copyWith(
                                        color: Colors.white, fontSize: 8),
                                  ),
                                  alignment: Alignment.center,
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  width: 66,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(
                                          color: Colors.green, width: 1),
                                      borderRadius: BorderRadius.circular(102)),
                                  child: Text(
                                    "Paid",
                                    style: appBarStyle.copyWith(
                                        color: Colors.white, fontSize: 8),
                                  ),
                                ),
                        ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
