import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../screens/auth/login.dart';
import '../../screens/home/home_screen.dart';

class FireAuth extends GetxController {
  TextEditingController teacherId = TextEditingController();
  RxBool isLoading = false.obs;
  RxList TeacherList = <DocumentSnapshot>[].obs;
  var box = GetStorage();
  RxBool isBanned = false.obs;

  @override
  void onInit() {
    getTeacherList();
    super.onInit();
  }

  // 1716225252433

  Future<List> getTeacherList() async {
    isLoading.value = true;
    TeacherList.clear();
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('LeaderTeachers').get();
      TeacherList.assignAll(snapshot.docs);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
    return TeacherList;
  }

  void logOut() async {
    isLoading.value = true;
    try {
      box.write('isLogged', null);
      Get.off(Login());
      isLoading.value = true;
    } catch (e) {
      Get.snackbar(
        "Logout",
        "Something went wrong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
    isLoading.value = false;
  }


  void signIn(String userId) async {
    await getTeacherList();
     isLoading.value = true;
    var holat = true;
    int i = 0;
    isLoading.value = true;
    try {

      while (holat) {
        if (TeacherList[i]['items']['uniqueId'] == userId) {
          holat = false;
          box.write('teacherName', TeacherList[i]['items']['name']);
          box.write('teacherSurname', TeacherList[i]['items']['surname']);
          box.write('teacherId', TeacherList[i]['items']['uniqueId']);
          box.write('teacherDocId', TeacherList[i].id);
          isBanned.value = TeacherList[i]['items']['isBanned'];
          box.write('isLogged', true);
          Get.off(HomeScreen());


        } else {
          holat = true;
          i++;

        }
      }

      isLoading.value = true;
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        "Foydalanuvchi topilmadi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
    isLoading.value = false;
  }




}
