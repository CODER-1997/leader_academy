import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:leader/controllers/students/student_controller.dart';

import '../../constants/utils.dart';
import '../../models/student_model.dart';

class HomeWorkController extends GetxController {
  RxBool isLoading = false.obs;









  TextEditingController reasonOfBeingAbsent = TextEditingController();
  StudentController studentController = Get.put(StudentController());

  RxString selectedAbsenseReason = "".obs;




  // Check student study inteval by ..

  void setHomework(
    String documentId,
    String groupId,
    String studentId,
    Map hasReason,
    bool isDone,
    String subject
  ) async {
    isLoading.value = true;
   // try {
      // Retrieve the document reference
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('LeaderStudents')
          .doc(documentId);

      // Get the current document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> currentMap =
          Map<String, dynamic>.from(documentSnapshot['items'] ?? {});
      // Get the current array field value
      List<dynamic> currentArray =
          List<dynamic>.from(currentMap['homeWorks'] ?? []);

      // Append the new item to the array

      // find element by month and year
      int index = -1;
      for (int i = 0; i < currentArray.length; i++) {
        if (currentArray[i]['studyDay'] == studentController.selectedStudyDate.value && currentArray[i]['groupId'] == groupId) {
          index = i;
          break;
        }
      }

      if (index == (-1)) {
        currentArray.add({
          'studyDay': studentController.selectedStudyDate.value,
          'groupId': groupId,
          'studentId': studentId,
          'hasReason': hasReason,
          'isDone': isDone,
          'subject': subject
        });
      } else {
        currentArray[index] = {
          'studyDay': studentController.selectedStudyDate.value,
          'groupId': groupId,
          'studentId': studentId,
          'hasReason': hasReason,
          'isDone': isDone,
          'subject': subject

        };
      }

      reasonOfBeingAbsent.clear();
      selectedAbsenseReason.value = "";
      // else{
      // currentArray.add({
      //   'paidDate': paidDate,
      //   'paidSum': payment.text.removeAllWhitespace,
      //   'id': generateUniqueId()
      // });
      // }

      // Update the document with the new array value
      await documentReference.update({
        'items.homeWorks': currentArray,
      });

      // Optional: Provide feedback to the user
      isLoading.value = false;
    // } catch (e) {
    //   // Handle errors here
    //   print('Error adding item to array: $e');
    //   Get.snackbar(
    //     'Error:${e}',
    //     e.toString(),
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    // }
  }

  void removeHomeWork(
    String documentId,
    String groupId,
    String studentId,
    Map hasReason,
    bool isDone,
  ) async {
    isLoading.value = true;
    try {
      // Retrieve the document reference
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('LeaderStudents')
          .doc(documentId);

      // Get the current document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> currentMap =
          Map<String, dynamic>.from(documentSnapshot['items'] ?? {});
      // Get the current array field value
      List<dynamic> currentArray =
          List<dynamic>.from(currentMap['homeWorks'] ?? []);

      // Append the new item to the array

      // find element by month and year
      int index = -1;
      for (int i = 0; i < currentArray.length; i++) {
        if (currentArray[i]['studyDay'] == studentController.selectedStudyDate.value) {
          index = i;
          break;
        }
      }

      if (index != (-1)) {
        currentArray.removeAt(index);
      }

      reasonOfBeingAbsent.clear();
      selectedAbsenseReason.value = "";
      // else{
      // currentArray.add({
      //   'paidDate': paidDate,
      //   'paidSum': payment.text.removeAllWhitespace,
      //   'id': generateUniqueId()
      // });
      // }

      // Update the document with the new array value
      await documentReference.update({
        'items.homeWorks': currentArray,
      });

      // Optional: Provide feedback to the user
      isLoading.value = false;
    } catch (e) {
      // Handle errors here
      print('Error adding item to array: $e');
      Get.snackbar(
        'Error:${e}',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

// Edit payment
}
