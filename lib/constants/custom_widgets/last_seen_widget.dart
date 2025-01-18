import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastSeenWidget extends StatelessWidget {
  final String dateTime;

  const LastSeenWidget({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String inputDate = dateTime.toString().substring(0,16);
     DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm');

    // Parse the input date
    DateTime givenDate = dateFormat.parse(inputDate);
    print("gggg ${givenDate.toString().substring(0,16)}");

    // Get the current date and time
    DateTime currentDate = DateTime.now();

    // Calculate the difference
    Duration difference = currentDate.difference(givenDate);

    Color textColor() {
      if (difference.inHours < 24) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }

    String text(){
      var txt = "";
      if(difference.inHours<24){
        txt =  difference.inHours.toString() + " soat oldin sms yuborildi" ;
      }
      if(difference.inDays>=1){
        txt =   difference.inDays.toString() + " kun oldin sms yuborildi";
      }

      return txt;
    }




    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: textColor(),

          )
      ),
      child: Text(
        text(),
        style: TextStyle(
            color: textColor(), fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }


}
