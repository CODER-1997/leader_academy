import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelStatistics extends StatelessWidget {
  final List students;

  ExcelStatistics({required this.students});

  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return box.read("isLogged") == "004422"
        ? InkWell(
            onTap: () async {
              // Create a new workbook
              final Workbook workbook = Workbook();
              final Worksheet sheet = workbook.worksheets[0];

              // Set the worksheet name
              sheet.name = 'Student Payments';

              // Add headers
               List<String> headers = [
                'F.I.O',           // Student Name Column
                'Sentabr', ' Kod',
                'Oktabr', ' Kod',
                'Noyabr', ' Kod',
                'Dekabr', ' Kod',
                'Yanvar', ' Kod',
                'Fevral', ' Kod',
                'Mart', ' Kod',
                'Aprel', ' Kod',
                'May', ' Kod',
                'Iyun', ' Kod',
                'Iyul', ' Kod',

              ];
              // Add headers to the sheet
              for (int i = 0; i < headers.length; i++) {
                sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
              }

              // Add student data rows
              for (int i = 0; i < students.length; i++) {
                var student = students[i];

                // Set surname in the first column
                sheet.getRangeByIndex(i + 2, 1).setText(student['surname']);

                // Process payments list (payment value and code alternately)
                List payments = student['payments'];
                int col = 2; // Start from the second column for payments
                for (int j = 0; j < payments.length; j += 2) {
                  // Set payment value
                  sheet.getRangeByIndex(i + 2, col).setNumber(payments[j].toDouble());
                  // Set payment code
                  sheet.getRangeByIndex(i + 2, col + 1).setNumber(payments[j + 1].toDouble());
                  col += 2; // Move to the next month (two columns forward)
                }
              }

              // Save the workbook
              final List<int> bytes = workbook.saveAsStream();
              workbook.dispose();

              // Save the file locally
              Directory directory = await getApplicationDocumentsDirectory();
              String filePath = '${directory.path}/StudentPayments.xlsx';
              File file = File(filePath);
              await file.writeAsBytes(bytes);

              // Share the file via Telegram or other apps
              Share.shareXFiles([XFile(filePath)],
                  text: 'Here is the student payment details Excel file.');
              print('Excel file shared: $filePath');
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
