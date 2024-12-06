import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Emptiness extends StatelessWidget {


  final String title ;
  const Emptiness({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty.png',
            width: 111,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 16),
          ),

        ],
      ),
    );
  }
}
