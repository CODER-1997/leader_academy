import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leader/constants/theme.dart';
import 'package:leader/screens/profil/profil.dart';
import 'package:leader/screens/students/students.dart';
import 'package:upgrader/upgrader.dart';

import '../groups/groups.dart';

class HomeScreen extends StatelessWidget {
  static RxInt currentIndex = 0.obs;
  RxList screens = [Groups(),Students() , Profil()].obs;
  GetStorage box = GetStorage();


  @override
  Widget build(BuildContext context) {
    return Obx(() =>   Scaffold(
          backgroundColor: homePagebg,

      body: UpgradeAlert(

        upgrader: Upgrader(
            minAppVersion: '1.0.0+12',
            appcastConfig: AppcastConfiguration(
              supportedOS: ['android'],
              url: "",
            )),
        child: Container(
          height: Get.height,
          // padding: EdgeInsets.only(left: 16,right: 16,top: 16),
          child: screens[currentIndex.value],
        ),
      ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.black,
            currentIndex: currentIndex.value,
            onTap: (int index) {
              currentIndex.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch_rounded),
                label: 'Groups'.tr.capitalizeFirst,
              ), BottomNavigationBarItem(
                icon: Icon(Icons.groups),
                label: 'Students'.tr.capitalizeFirst,
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'profile'.tr.capitalizeFirst,
              ),
            ],
          ),
        ));
  }
}
