
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LastSeenWidget extends StatelessWidget {
  final String dateTime;

  const LastSeenWidget({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration difference = DateTime.now().difference(DateTime.parse(dateTime));

    Color textColor;
    if (difference.inDays <= 1) {
      textColor = Colors.green;
    } else if (difference.inDays <= 3) {
      textColor = Colors.orange;
    } else {
      textColor = Colors.red;
    }

    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor,
          
        )
      ),
      child: Text(
        'Tekshirildi: ${_formatDuration(difference)} oldin',
        style: TextStyle(color: textColor, fontSize: 12,fontWeight: FontWeight.w700),
      ),
    );
  }


  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} kun';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} soat ';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minut ';
    } else {
      return 'Yaqindagina';
    }
  }
}
