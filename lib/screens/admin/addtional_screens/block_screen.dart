import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leader/constants/custom_widgets/gradient_button.dart';
import 'package:leader/controllers/device_controllers/device_controller.dart';

class BlockedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text(
              "Ilova faoliyati vaqtinchalik tugatildi..",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  DeviceChecker.getDeviceId();
                },
                child: CustomButton(
                  text: "Qayta urinish",
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
