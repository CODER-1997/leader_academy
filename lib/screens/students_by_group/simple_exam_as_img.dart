import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_navigation/src/nav2/get_router_delegate.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class ExamResultsAsImg extends StatefulWidget {
  final List examResults;

  ExamResultsAsImg({required this.examResults});

  @override
  _ExamResultsAsImgState createState() => _ExamResultsAsImgState();
}

class _ExamResultsAsImgState extends State<ExamResultsAsImg> {
  ScreenshotController screenshotController = ScreenshotController();

  Color getColor(double num) {
    if (num >= 70) {
      return Colors.green;
    } else if (num >= 50 && num <= 69) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Natijalar')),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            children: widget.examResults.map(
              (result) {
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: getColor(
                            double.parse(result['percent'].toString()))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('${result['order']}'),
                                SizedBox(
                                  width: 12,
                                ),
                                Text('${result['name']}'
                                    .toString()
                                    .capitalizeFirst!),
                                SizedBox(
                                  width: 4,
                                ),
                                Text('${result['surname']}'.capitalizeFirst!),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${result['grade']}' +
                                      "/" +
                                      '${result['questionCount']}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '${result['percent']}%',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ));
              },
            ).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _generateAndShareImage();
        },
        child: Icon(Icons.telegram,color: Colors.blue,size: 57,),
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
