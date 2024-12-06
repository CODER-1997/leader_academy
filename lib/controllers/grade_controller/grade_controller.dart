import 'package:leader/constants/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../models/grades_model.dart';

class GradeController extends GetxController {
  RxBool isLoading = false.obs;

  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('LeaderGrading');
  RxInt order = 0.obs;
  GetStorage box = GetStorage();

  void addGrading(String group) async {
    isLoading.value = true;
    try {
      GradeModel newData = GradeModel(
          date: DateFormat('d MMMM, y').format(DateTime.now()),
          time: DateFormat('HH:mm:ss').format(DateTime.now()),
          group: group, uniqueId:generateUniqueId());
      // Create a new document with an empty list
      await _dataCollection.add({
        'items': newData.toMap(),
      });
      // Get.snackbar(
      //   "Success !",
      //   "New group added successfully !",
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
      isLoading.value = false;
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error:${e}',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoading.value = false;

// Firestore
  }

  //


  void deleteGrade(String documentId) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderGrading').doc(documentId);

      // Update the desired field
      await documentReference.delete();
       isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }
  // Student add grade

  void editGrading(  String uniqueId,   String documentId,
      String gradeDate,
      String gradeTime,
      String grade,) async {
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
      List<dynamic>.from(currentMap['grades'] ?? []);
      // Append the new item to the array

      // find element by month and year
      int index = -1;
      for (int i = 0; i < currentArray.length; i++) {
        if (currentArray[i]['id'] == uniqueId) {
          index = i;
          break;
        }
      }
      if (index != -1) {
        currentArray[index] = {
          'date': gradeDate,
          'time': gradeTime,
          'grade': grade,
          'id': uniqueId
        };
      }

      // Update the document with the new array value
      await documentReference.update({
        'items.grades': currentArray,
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

  void addGrade(String documentId,
      String gradeDate,
      String gradeTime,
      String grade,
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
      List<dynamic>.from(currentMap['grades'] ?? []);

      currentArray.add({
        'date': gradeDate,
        'time': gradeTime,
        'grade': grade,
        'id': generateUniqueId()
      });
      // }

      // Update the document with the new array value
      await documentReference.update({
        'items.grades': currentArray,
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
}
