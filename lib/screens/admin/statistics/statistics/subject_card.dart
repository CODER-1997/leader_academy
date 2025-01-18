import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/screens/admin/students/super_search.dart';

import '../../../../constants/text_styles.dart';

class SubjectCard extends StatelessWidget {


  final String subject;
  final String img;
  final List students;
  SubjectCard({required this.subject,required this.img, required this.students});

  bool studentHasSubject( List groups,String subject){
    bool inGroup = false;

    for(var item in groups){
      if(item['subject'] == subject){
        inGroup = true ;
        print('true');
        break;
      }
    }


    return inGroup;

  }

  List studentsBySubject(List students, String subject){
    List _students = [];
    for(var item in students){
      print(item);

      if(studentHasSubject(item['items']['groups'],subject)){
         _students.add(item);
      }
    }

    return _students;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(SuperSearch(students: studentsBySubject(students, "${subject}")));
      },
      child: Container(
        child: ListTile(

          leading: Image.asset('assets/$img.png',width: 75,height: 75,),
          title: Text('$subject',style: appBarStyle,),
          trailing: Container(
            height:40,
            width:40,

            decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(121),
                color: Colors.green.withOpacity(.88)
            ),
            child: Text('${studentsBySubject(students, "${subject}").length}',style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700
            ),),
            alignment: Alignment.center,
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
      ),
    );
  }
}
