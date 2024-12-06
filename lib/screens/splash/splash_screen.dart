import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leader/controllers/students/student_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StudentController studentController = Get.put(StudentController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff012931), // Set the background color
      body: Stack(
        children: [
          // Centered Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png', // Replace with your logo asset
                  width: 150, // Adjust size as needed
                  height: 150,
                ),
              ],
            ),
          ),
          // Circular Progress Indicator at the Bottom
          Positioned(
            bottom: 30, // Position above the bottom of the screen
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xffC9F2D2)), // Customize color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
