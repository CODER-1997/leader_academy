import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../constants/utils.dart';
import '../../models/teacher_model.dart';


class TeachersController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController TeacherName = TextEditingController();
  TextEditingController TeacherNameEdit = TextEditingController();

  TextEditingController TeacherSurname = TextEditingController();
  TextEditingController TeacherSurnameEdit = TextEditingController();

  RxList teacherGroups = [].obs;
  RxList teacherGroupsEdit = [].obs;

  RxList teacherGroupIds = [].obs;
  RxList teacherGroupIdsEdit = [].obs;

  setValues(
      String name,
      String surname,
      ) {
    TeacherNameEdit = TextEditingController(text: name);
    TeacherSurnameEdit = TextEditingController(text: surname);
  }

  final CollectionReference _dataCollection =
  FirebaseFirestore.instance.collection('LeaderTeachers');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList LeaderTeachers = [].obs;

  Future<void> fetchTeachers() async {
    isLoading.value = true;
    QuerySnapshot querySnapshot = await _firestore.collection('LeaderTeachers').get();
    LeaderTeachers.clear();
    for (var doc in querySnapshot.docs) {
      LeaderTeachers.add({
        'teacher_name': (doc.data() as Map<String, dynamic>)['items']['name'],
      });
    }
    isLoading.value = false;
  }



  @override
  void onInit() {
    fetchTeachers();
    super.onInit();
  }




  void addNewTeacher() async {
    isLoading.value = true;
    try {
      TeacherModel newData = TeacherModel(
        name: TeacherName.text,
        surname: TeacherSurname.text,
        uniqueId: generateUniqueId(),
        isBanned: false,
        groupIds: teacherGroupIds.value
        ,
        groups: teacherGroups.value,
      );
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
      TeacherName.clear();
      Get.back();
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
  }

  void editTeacher(String documentId) async {
    isLoading.value = true;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
      _firestore.collection('LeaderTeachers').doc(documentId);
      // Update the desired field
      await documentReference.update({
        'items.name': TeacherNameEdit.text,
        'items.surname': TeacherSurnameEdit.text,
        'items.groups': teacherGroupsEdit.value,
        'items.groupIds': teacherGroupIdsEdit.value
      });
      isLoading.value = false;
      Get.back();

    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void blockTeacher(String documentId, bool isBanned) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
      _firestore.collection('LeaderTeachers').doc(documentId);

      // Update the desired field
      await documentReference.update({
        'items.isBanned': isBanned,
      });
      isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void deleteTeacher(String documentId) async {
    isLoading.value = true;
    Get.back();

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
      _firestore.collection('LeaderTeachers').doc(documentId);

      // Update the desired field
      await documentReference.delete();
      isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }
}
