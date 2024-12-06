import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import '../../../constants/text_styles.dart';
import '../../../constants/theme.dart';
import '../../../controllers/admin/teachers_controller.dart';

class Teacherinfo extends StatelessWidget {
  final String documentId;

  Teacherinfo({
    required this.documentId,
  });

  TeachersController teachersController = Get.put(TeachersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homePagebg,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(1.0),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('LeaderTeachers')
                  .doc(documentId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  var documentData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: CupertinoColors.white),
                        margin: EdgeInsets.all(1),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(111),
                                  child:
                                      Image.asset('assets/teacher_avatar.png'),
                                )),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Id:',
                              style: appBarStyle.copyWith(color: titleColor),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            SelectableText(
                              '${documentData['items']['uniqueId']}',
                              style: appBarStyle,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(1),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: CupertinoColors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Teacher name: ',
                              style: appBarStyle.copyWith(
                                  color: CupertinoColors.systemGrey, fontSize: 14,),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                                '${documentData['items']['name']} ${documentData['items']['surname']}',
                                style: appBarStyle.copyWith(
                                    color: Colors.black, fontSize: 14)),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(1),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: CupertinoColors.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status',
                              style: appBarStyle.copyWith(
                                color: CupertinoColors.systemGrey, fontSize: 14,),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${documentData['items']['isBanned'] == true ? "Chetlashtrilgan" : "Ishlayapti"}',
                              style: TextStyle(
                                  color: documentData['items']['isBanned']
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          teachersController.blockTeacher(
                              documentId, !documentData['items']['isBanned']);
                        },
                        child: Container(
                          margin: EdgeInsets.all(1),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: CupertinoColors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${documentData['items']['isBanned'] ? "Blokdan chiqarish" : "Bloklash"}',
                                style: TextStyle(
                                    color: documentData['items']['isBanned'] ==
                                            false
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                // If no data available

                else {
                  return Text('No data'); // No data available
                }
              })),
    );
  }
}
