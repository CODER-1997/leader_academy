import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/auth/login_controller.dart';
import '../admin/admin_home_screen.dart';
import '../home/home_screen.dart';

class Login extends StatelessWidget {
  Rx isLogin = true.obs;
  Rx isVisible = false.obs;

  FireAuth auth = Get.put(FireAuth());
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff123778), Color(0xff123778)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/logo.png'),

            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: auth.teacherId,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter your teacher id :',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: () {
                if(auth.teacherId.text == '0094' || auth.teacherId.text == '1105'){
                  box.write('isLogged', auth.teacherId.text);
                  Get.offAll(AdminHomeScreen());
                }
                else {
                  auth.signIn(auth.teacherId.text);
                }
              },
              child: Text('login'.tr.capitalizeFirst!),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
