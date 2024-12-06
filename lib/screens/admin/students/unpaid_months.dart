import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../constants/custom_widgets/gradient_button.dart';
import '../../../constants/date_utils.dart';
import '../../../constants/theme.dart';
import '../../../services/sms_service.dart';

class UnpaidMonths extends StatelessWidget {
  final List months;
  final String studentPhone;
  final String studentName;
  final String studentSurname;

  UnpaidMonths(
      {required this.months,
      required this.studentPhone,
      required this.studentName,
      required this.studentSurname});

  SMSService _smsService = SMSService();
  RxBool messageLoader = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: months.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(4),
                    title: Text(months[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: studentPhone.isNotEmpty
          ? Container(
              margin: EdgeInsets.all(4),
              child: InkWell(
                  onTap: () async {
                    messageLoader.value = true;




                    _smsService.sendSMS(
                        studentPhone,
                            "\nHurmatli ota ona ,\nFarzandingiz ${studentName.capitalizeFirst!} ${studentSurname.capitalizeFirst!.removeAllWhitespace

                        }ning " "${ translateMonthYearList(months ).join(',')} ${months.length >1 ?'oylari' :'oyi'} uchun oylik to'lovi kechikkanini ma'lum qilamiz.");

                    _smsService.sendSMS(
                        studentPhone,
                        "\nIltimos, qarzni imkon qadar tezroq to'lang. ");

                    messageLoader.value = false;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Your message has been sent!'),
                      backgroundColor: Colors.red,
                    ));
                  },
                  child: Obx(() => CustomButton(
                      color: Colors.red,
                      text: messageLoader.value == true
                          ? "Sending..."
                          : 'Notify about debt'))))
          : SizedBox(),
    );
  }
}
