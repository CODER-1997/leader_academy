import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class CefrResultsAsImg extends StatefulWidget {
  final  examResults;

  CefrResultsAsImg({required this.examResults});

  @override
  _CefrResultsAsImgState createState() => _CefrResultsAsImgState();
}

class _CefrResultsAsImgState extends State<CefrResultsAsImg> {
  ScreenshotController screenshotController = ScreenshotController();


  Color getColor(String band){
    if(band == "B2" || band == "C1" || band == "C2"){
      return Colors.green;
    }
    else if(band == "B1"){
      return Colors.yellow;

    }
    return Colors.red;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam Results')),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: _buildExamResultsTable(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _generateAndShareImage();
        },
        child: Icon(Icons.share),
      ),
    );
  }

  /// Function to create a table for exam results
  Widget _buildExamResultsTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        border: TableBorder.all(), // Adds border around the table and cells
        columnWidths: {
          0: FlexColumnWidth(2), // Name column width
          1: FlexColumnWidth(3), // Score column width
          2: FlexColumnWidth(3), // Score column width
          3: FlexColumnWidth(3), // Score column width
        },
        children: [
          // Table Header
          TableRow(
            decoration: BoxDecoration(color: Colors.grey[300]),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('T/R', style: TextStyle(fontWeight: FontWeight.bold)),
              ),   Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Ism', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Familiyasi', style: TextStyle(fontWeight: FontWeight.bold)),
              ), Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Cefr Natijasi', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          // Table Rows (Exam Results)
          for (var result in widget.examResults)
            TableRow(
              decoration: BoxDecoration(
                color:getColor(result["cefr_band"].toString()) // Alternate row colors
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(result['order'].toString().capitalizeFirst!),
                ),Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(result['name'].toString().capitalizeFirst!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(result['surname'].toString().capitalizeFirst!,
                    style: TextStyle(
                        fontSize: 10,
                      fontWeight: FontWeight.w900
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(result['cefr_band'].toString().capitalizeFirst!,
                  style: TextStyle(
                      fontWeight: FontWeight.w900

                  ),),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _generateAndShareImage() async {
    // Capture the widget as an image
    Uint8List? imageBytes = await screenshotController.capture();
    if (imageBytes != null) {
      // Save the image as a temporary file
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/exam_results.png').create();
      file.writeAsBytesSync(imageBytes);

      // Share the image via Telegram or other apps
      await Share.shareXFiles([XFile(file.path)], text: 'Natijalar');
    }
  }
}
