import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../constants/utils.dart';
import '../../models/student_model.dart';

class StudentController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController phone = TextEditingController();

  //

  TextEditingController nameEdit = TextEditingController();
  TextEditingController surnameEdit = TextEditingController();
  TextEditingController phoneEdit = TextEditingController();

   RxList selectedGroupId = [].obs;
   RxList selectedGroups = [].obs;


  RxBool isFreeOfCharge = false.obs;

  final RxList LeaderGroups = [].obs;
  final RxList LeaderStudents = [].obs;
  final RxList LeaderStudents2 = [].obs;
  RxBool loadGroups = false.obs;
  RxBool loadStudents = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchGroups() async {
    loadGroups.value = true;
    QuerySnapshot querySnapshot =
        await _firestore.collection('LeaderGroups').get();
    LeaderGroups.clear();
    for (var doc in querySnapshot.docs) {
      LeaderGroups.add({
        'group_name': (doc.data() as Map<String, dynamic>)['items']['name'],
        'group_id': (doc.data() as Map<String, dynamic>)['items']['uniqueId'],
        'subject': (doc.data() as Map<String, dynamic>)['items']['subject'],
      });
    }
    loadGroups.value = false;
  }

  RxList students = [].obs;

  Future<void> fetchStudents() async {
    students.clear();
    QuerySnapshot querySnapshot =
        await _firestore.collection('LeaderStudents').where('items.isDeleted',isEqualTo: false).get();
    for (var doc in querySnapshot.docs) {
      students.add({
        'name': (doc.data() as Map<String, dynamic>)['items']['name'],
        'phone': (doc.data() as Map<String, dynamic>)['items']['phone'],
        'surname': (doc.data() as Map<String, dynamic>)['items']['surname'],
        'groups': (doc.data() as Map<String, dynamic>)['items']['groups'],
        'id': doc.id,
      });
    }
    print(students);
  }

  setValues(
    String name,
    String surname,
    String phone,
   ) {
    nameEdit = TextEditingController(text: name);
    surnameEdit = TextEditingController(text: surname);
    phoneEdit = TextEditingController(text: phone);
   }

  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('LeaderStudents');

  @override
  void onInit() {
    super.onInit();
  }

  RxInt orderInGroup = 0.obs;

  RxString paymentType = "monthly".obs;
  Rx monthly = true.obs;
  TextEditingController yearlyFee = TextEditingController();
  TextEditingController paymentCode = TextEditingController();

  void addNewStudent( String groupId,String subject) async {
    isLoading.value = true;
    try {
      StudentModel newData = StudentModel(
          name: name.text,
          surname: surname.text,
          phone: phone.text.toString().removeAllWhitespace,
          payments: [],
          uniqueId: generateUniqueId(),
           startedDay: paidDate.value,
          isDeleted: false,
           studyDays: [],
          isFreeOfcharge: isFreeOfCharge.value,
          orderInGroup: orderInGroup.value,
          exams: [],
          grades: [],
          yeralyFee: yearlyFee.text.isNotEmpty ? int.parse(yearlyFee.text.removeAllWhitespace) : 0,
          paymentType: paymentType.value,
          homeWorks: [],
           groups: [{
             'groupId':groupId,
             'subject':subject
           }]);
      // Create a new document with an empty list
      await _dataCollection.add({
        'items': newData.toMap(),
      });
      Get.back();

      //
      // Get.snackbar(
      //   "Success !",
      //   "New student added successfully !",
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.TOP,
      // );
      print('Data added to the list in Firestore');
      isLoading.value = false;
      name.clear();
      phone.clear();
      surname.clear();
      paidDate.value = '';
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error:${e}',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
    isLoading.value = false;

// Firestore
  }

  //
  //student attach group

   attachGroup (
    String documentId,
    String groupId,
    String subject,
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
            List<dynamic>.from(currentMap['groups'] ?? []);
        // Append the new item to the array

        currentArray.add({
          'groupId':groupId,
          'subject':subject
        });

        // Update the document with the new array value
        await documentReference.update({
          'items.groups': currentArray,
        });

        // Optional: Provide feedback to the user

        payment.clear();
        paidDate.value = '';
        isLoading.value = false;
        paymentComment.clear();
        Get.back();
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

  void editStudent(String documentId) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderStudents').doc(documentId);

      // Update the desired field
       await documentReference.update({
        'items.name': nameEdit.text,
        'items.surname': surnameEdit.text,
        'items.phone': phoneEdit.text,
         'items.groups': selectedGroups,
        'items.startedDay': startedDay.value,
         'items.isFreeOfcharge': isFreeOfCharge.value,
      });
      Get.back();
      isLoading.value = false;
      paidDate.value = '';
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void updatePayment(String documentId , List payments) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =   _firestore.collection('LeaderStudents').doc(documentId);

      for (var payment in payments){
        payment['subject']="Matematika";
      }

      await documentReference.update({
        'items.payments': payments,
      });
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void recoverStudentItem(String documentId, String groupName) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderStudents').doc(documentId);

      // Update the desired field
      print('Selected group Id ${selectedGroupId.value}');
      await documentReference.update({
        'items.group': groupName,
      });
      isLoading.value = false;
      paidDate.value = '';
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void deleteStudent(String documentId) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderStudents').doc(documentId);

      // Update the desired field
      await documentReference.update({
        'items.isDeleted': true,
      });
      print('Deleted succesfully');
      Get.back();
      isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  void revoverGroupId(String documentId, String groupId) async {
    isLoading.value = true;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to update a specific document field by document ID
    try {
      isLoading.value = true;

      // Reference to the document
      DocumentReference documentReference =
          _firestore.collection('LeaderStudents').doc(documentId);

      // Update the desired field
      await documentReference.update({
        'items.groupId': groupId,
      });
      isLoading.value = false;
    } catch (e) {
      print('Error updating document field: $e');
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  // Calculate payment

  TextEditingController payment = TextEditingController( );
   TextEditingController paymentComment = TextEditingController();
   TextEditingController reasonOfBeingAbsent = TextEditingController();

   setCode(String code){
     paymentComment = TextEditingController(text: code);
   }

  RxString selectedAbsenseReason = "".obs;





  RxString paidDate = ''.obs;
  RxString startedDay = ''.obs;
  static DateTime date = DateTime.now();

  RxString selectedStudyDate = DateFormat('dd-MM-yyyy').format(date).toString().obs;
  static DateTime now = DateTime.now();

  showDate(RxString when) {
     showDatePicker(
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            context: Get.context!)
        .then((value) {
      date = value!;

      when.value = DateFormat('dd-MM-yyyy').format(date);
    });
  }

  showDate2(RxString when) {
    showDatePicker(
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
            context: Get.context!)
        .then((value) {
      date = value!;
      when.value = DateFormat('dd-MM-yyyy').format(date);
    });
  }

  RxBool courseFee = true.obs;

  void addPayment(String documentId, String paidDate,String subject) async {
    isLoading.value = true;
    if (payment.text.isNotEmpty) {
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
            List<dynamic>.from(currentMap['payments'] ?? []);
        // Append the new item to the array

        // find element by month and year
        // int index = -1;
        // for (int i = 0; i < currentArray.length; i++) {
        //   if (currentArray[i]['paidMonth'] == month &&
        //       currentArray[i]['paidYear'] == year) {
        //     index = i;
        //     break;
        //   }
        // }
        // if (index == -1) {
        //   currentArray.add({
        //     'paidDate': paidDate,
        //     'paidSum': payment.text,
        //
        //   });
        // }
        // else{
        currentArray.add({
          'paidDate': paidDate,
          'paidSum': payment.text.removeAllWhitespace,
          'courseFee': courseFee.value,
          'paymentCode': paymentComment.text,
          'id': generateUniqueId(),
           'subject':subject
        });

         await documentReference.update({
          'items.payments': currentArray,
        });

         isLoading.value = false;
        Get.back();
         paymentComment.clear();
         payment.clear();
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

  // Edit payment

  void editPayment(
    String documentId,
    String uniqueId,
  ) async {
    isLoading.value = true;
    if (payment.text.isNotEmpty) {
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
            List<dynamic>.from(currentMap['payments'] ?? []);
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
            'paidDate': paidDate.value,
            'paidSum': payment.text.removeAllWhitespace,
            'paymentCode': paymentComment.text,
             'id': uniqueId
          };
        }

        // Update the document with the new array value
        await documentReference.update({
          'items.payments': currentArray,
        });

        // Optional: Provide feedback to the user

        payment.clear();
        paidDate.value = '';
        isLoading.value = false;
        paymentComment.clear();
        Get.back();
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

  void deletePayment(
    String documentId,
    String uniqueId,
  ) async {
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
          List<dynamic>.from(currentMap['payments'] ?? []);
      // Append the new item to the array

      // find element by month and year
      print('deleting.....');
      int index = -1;
      for (int i = 0; i < currentArray.length; i++) {
        if (currentArray[i]['id'] == uniqueId) {
          index = i;
          break;
        }
      }
      if (index != -1) {
        currentArray.removeAt(index);
      }

      // Update the document with the new array value
      await documentReference.update({
        'items.payments': currentArray,
      });

      // Optional: Provide feedback to the user
      paymentComment.clear();
      payment.clear();
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

  // Check student study inteval by ..

  void setStudyDay(
    String documentId,
    String groupId,
    String studentId,
    Map hasReason,
    bool isAttended,
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
          List<dynamic>.from(currentMap['studyDays'] ?? []);

      // Append the new item to the array

      // find element by month and year
      int index = -1;
      for (int i = 0; i < currentArray.length; i++) {
        if (currentArray[i]['studyDay'] == selectedStudyDate.value && currentArray[i]['groupId'] == groupId) {
          index = i;
          break;
        }
      }

      if (index == (-1)) {
        currentArray.add({
          'studyDay': selectedStudyDate.value,
          'groupId': groupId,
          'studentId': studentId,
          'hasReason': hasReason,
          'isAttended': isAttended,
          'subject': subject,
        });
      } else {
        currentArray[index] = {
          'studyDay': selectedStudyDate.value,
          'groupId': groupId,
          'studentId': studentId,
          'hasReason': hasReason,
          'isAttended': isAttended,
          'subject': subject,

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
        'items.studyDays': currentArray,
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

  void removeStudyDay(
    String documentId,
    String groupId,
    String studentId,
    Map hasReason,
    bool isAttended,
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
          List<dynamic>.from(currentMap['studyDays'] ?? []);

      // Append the new item to the array

      // find element by month and year
      int index = -1;
      for (int i = 0; i < currentArray.length; i++) {
        if (currentArray[i]['studyDay'] == selectedStudyDate.value) {
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
        'items.studyDays': currentArray,
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

  void editExam(String documentId, String uniqueId, String from, String howMany,
      String examTitle, String examDate) async {
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
          List<dynamic>.from(currentMap['exams'] ?? []);
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
          'title': examTitle,
          'from': from,
          'howMany': howMany,
          'examDate': examDate,
          'id': uniqueId
        };
      }

      // Update the document with the new array value
      await documentReference.update({
        'items.exams': currentArray,
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

  void addExam(
    String documentId,
    String examDate,
    String from,
    String howMany,
    String title,
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
          List<dynamic>.from(currentMap['exams'] ?? []);
      // Append the new item to the array

      // find element by month and year
      // int index = -1;
      // for (int i = 0; i < currentArray.length; i++) {
      //   if (currentArray[i]['paidMonth'] == month &&
      //       currentArray[i]['paidYear'] == year) {
      //     index = i;
      //     break;
      //   }
      // }
      // if (index == -1) {
      //   currentArray.add({
      //     'paidDate': paidDate,
      //     'paidSum': payment.text,
      //
      //   });
      // }
      // else{
      currentArray.add({
        'title': title,
        'from': from,
        'howMany': howMany,
        'examDate': examDate,
        'id': generateUniqueId()
      });
      // }

      // Update the document with the new array value
      await documentReference.update({
        'items.exams': currentArray,
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
