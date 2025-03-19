import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:leader/screens/admin/students/super_search.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:leader/controllers/groups/group_controller.dart';
import '../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../constants/custom_widgets/gradient_button.dart';
import '../../constants/text_styles.dart';
import '../../constants/utils.dart';
import '../../controllers/students/student_controller.dart';
import '../../services/sms_service.dart';
import '../admin/students/student_info.dart';

class Attendance extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupDocId;
  final String subject;

  Attendance({
    required this.groupId,
    required this.groupName,
    required this.groupDocId,
    required this.subject,
  });

  static RxBool messageLoader = false.obs;

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  GetStorage box = GetStorage();

  RxList students = [].obs;

  RxList selectedStudents = [].obs;

  RxBool messageLoader2 = false.obs;

  RxBool messageLoader3 = false.obs;

  TextEditingController customMessage = TextEditingController();

  RxBool isStudentChoosen = false.obs;

  StudentController studentController = Get.put(StudentController());

  final _formKey = GlobalKey<FormState>();

  RxList studentList = [].obs;

  SMSService _smsService = SMSService();

  RxList list = [].obs;

  RxList attendedStudents = [].obs;

  RxList unattendedStudents = [].obs;

  GroupController groupController = Get.put(GroupController());

  double calculatePercentOfPayments(int paidSum, String totalFee) {
    print("${totalFee.toString().removeAllWhitespace}");
    var percent = paidSum / int.parse(totalFee.toString().removeAllWhitespace);
    print("${percent}");

    return percent <= 1 ? percent : 1;
  }

  Color calculatePercentOfPaymentsColor(int paidSum, String totalFee) {
    var percent = paidSum / int.parse(totalFee.toString().removeAllWhitespace);

    if (percent < 0.5) {
      return Colors.red;
    } else if (percent >= 0.5 && percent <= 0.79) {
      return Color(0xffff7528);
    }
    return Colors.green;
  }

  String setName(String name, String fam) {
    String txt = box.read("attendance_text").toString();
    txt = txt.replaceAll("#ismi", "$name".capitalizeFirst!);
    txt = txt.replaceAll("#fam", "$fam".capitalizeFirst!);
    txt = txt.replaceAll("#fan", "${widget.subject}".capitalizeFirst!);
    txt = txt.replaceAll("#guruh", "${widget.groupName}".capitalizeFirst!);
    txt = txt.replaceAll("#sana",
        "${DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()}");

    return txt;
  }

  @override
  Widget build(BuildContext context) {
    print("groub ${widget.subject}");

    return Scaffold(
      backgroundColor: Color(0xffe8e8e8),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   width: Get.width-32,
            //   padding: const EdgeInsets.symmetric(horizontal: 32,vertical: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(4)
            //   ),
            //   child: Text(widget.lessonType.capitalizeFirst! + " Lesson",style: appBarStyle,),
            // ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Form(
                key: _formKey,
                child: TextField(
                  decoration: buildInputDecoratione('Qidirish'),
                  onTap: () {
                    Get.to(SuperSearch(students: studentList));
                  },
                ),
              ),
            ),
            SizedBox(height: 4),
            StreamBuilder(
                stream:   FirebaseFirestore.instance
                        .collection('LeaderStudents').where('items.groups',arrayContains: {
                          "groupId":widget.groupId,
                  'subject':widget.subject

                }).where('items.isDeleted',isEqualTo: false)
                        .snapshots(includeMetadataChanges: true),

                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (snapshot.hasData) {
                    var list = snapshot.data!.docs;

                    students.clear();
                    for (int i = 0; i < list.length; i++) {

                        studentList.add(list[i]);
                        students.add({
                          'name': list[i]['items']['name'],
                          'id': list[i].id,
                          'surname': list[i]['items']['surname'],
                          'payments': list[i]['items']['payments'],
                          'studyDays': list[i]['items']['studyDays'],
                          'uniqueId': list[i]['items']['uniqueId'],
                          'phone': list[i]['items']['phone'],
                          'startedDay': list[i]['items']['startedDay'],
                          'yearlyFee': list[i]['items']['yeralyFee'].toString(),
                          'isFreeOfcharge': list[i]['items']['isFreeOfcharge'],
                        });

                      students.sort(
                          (a, b) => (a['surname']).compareTo(b['surname']));
                    }

                    return students.length != 0
                        ? Obx(() => Column(
                              children: [
                                isStudentChoosen.value
                                    ? Container(
                                        padding: EdgeInsets.all(16),
                                        width: Get.width,
                                        decoration:
                                            BoxDecoration(color: Colors.green),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${selectedStudents.length} student(s) selected',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 22,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        isStudentChoosen.value =
                                                            false;
                                                        selectedStudents
                                                            .clear();
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                                SizedBox(
                                                  height: 22,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        if (selectedStudents
                                                                .length ==
                                                            students.length) {
                                                          selectedStudents
                                                              .clear();
                                                        } else {
                                                          selectedStudents
                                                              .clear();
                                                          selectedStudents
                                                              .addAll(students);
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons.select_all,
                                                        color: Colors.white,
                                                      )),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                for (int i = 0; i < students.length; i++)
                                  Container(
                                    key: ValueKey(students[i]['id']),
                                    child: GestureDetector(
                                      onLongPress: () {
                                        isStudentChoosen.value = true;
                                        if (box.read('attendance_text') ==
                                            null) {
                                          box.write('attendance_text',
                                              "Farzandingiz #ismi #fam  #fan #guruh darsiga kelmadi . #sana");
                                        }
                                      },
                                      onTap: () {
                                        if ((box.read('isLogged') == '004422' ||
                                                box.read('isLogged') ==
                                                    '0094') &&
                                            isStudentChoosen.value == false) {

                                          Get.to(StudentInfo(
                                            studentId: students[i]['id'],
                                            subject: widget.subject,
                                          ));
                                        }
                                        if (isStudentChoosen.value == true) {
                                          print('Working....');
                                          if (selectedStudents
                                              .contains(students[i])) {
                                            selectedStudents.removeWhere(
                                                (el) => el == students[i]);
                                          } else {
                                            selectedStudents.add(students[i]);
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 1),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: CupertinoColors.white),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                isStudentChoosen.value
                                                    ? Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 20,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color: selectedStudents
                                                                    .contains(students[
                                                                        i])
                                                                ? Colors.green
                                                                : Colors.white,
                                                            border: Border.all(
                                                                color: selectedStudents
                                                                        .contains(
                                                                            students[
                                                                                i])
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .grey,
                                                                width: 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                          size: 12,
                                                        ),
                                                      )
                                                    : Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: students[i][
                                                                    'isFreeOfcharge'] ==
                                                                true
                                                            ? Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/verified.png',
                                                                    width: 25,
                                                                    color: CupertinoColors
                                                                        .systemYellow,
                                                                  ),
                                                                  Text(
                                                                    "${i + 1}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(
                                                                child: Text(
                                                                  "${i + 1}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                width: 25,
                                                                height: 25,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    color: hasDebt(students[i]
                                                                            [
                                                                            'payments'])
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .green),
                                                              ),
                                                      ),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      width: Get.width / 2.5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            students[i]['surname']
                                                                    .toString()
                                                                    .capitalizeFirst! +
                                                                " " +
                                                                students[i]
                                                                        ['name']
                                                                    .toString()
                                                                    .capitalizeFirst!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          // students[i]['phone']
                                                          //         .toString()
                                                          //         .isEmpty
                                                          //     ? Text(
                                                          //         "Phone number is empty",
                                                          //         style: TextStyle(
                                                          //             color: Colors
                                                          //                 .red),
                                                          //       )
                                                          //     : SizedBox()
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 16,
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    students[i]['yearlyFee']
                                                                .toString() !=
                                                            '0'
                                                        ? LinearPercentIndicator(
                                                            animationDuration:
                                                                2000,
                                                            animation: true,
                                                            barRadius:
                                                                Radius.circular(
                                                                    12),
                                                            center: Text(
                                                              "${calculatePercentOfPayments(calculateTotalFee(students[i]['payments']), students[i]['yearlyFee']) * 100}"
                                                                      .substring(
                                                                          0,
                                                                          2) +
                                                                  "%",
                                                              style: TextStyle(
                                                                  fontSize: 6,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            width:
                                                                Get.width / 3,
                                                            lineHeight: 10.0,
                                                            percent: calculatePercentOfPayments(
                                                                calculateTotalFee(
                                                                    students[i][
                                                                        'payments']),
                                                                students[i][
                                                                    'yearlyFee']),
                                                            backgroundColor:
                                                                CupertinoColors
                                                                    .systemGrey3,
                                                            progressColor: calculatePercentOfPaymentsColor(
                                                                calculateTotalFee(
                                                                    students[i][
                                                                        'payments']),
                                                                students[i][
                                                                    'yearlyFee']),
                                                          )
                                                        : SizedBox(),
                                                    hasDebtFromPayment(students[
                                                                    i]
                                                                ['payments']) &&
                                                            students[i]['yearlyFee']
                                                                    .toString() ==
                                                                '0'
                                                        ? Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        4),
                                                            child: Text(
                                                              "To'lovda chalasi bor !",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.red,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12)),
                                                          )
                                                        : SizedBox(),
                                                    students[i]['isFreeOfcharge'] ==
                                                                false &&
                                                            students[i]['yearlyFee']
                                                                    .toString() ==
                                                                '0'
                                                        ? (calculateUnpaidMonths(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        students[i]
                                                                            [
                                                                            'payments'],
                                                                     )
                                                                    .length !=
                                                                0
                                                            ? Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child: Text(
                                                                  '${calculateUnpaidMonths(students[i]['studyDays'], students[i]['payments'],   ).length} oylik to\'lov qolgan',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .red,
                                                                        width:
                                                                            1)),
                                                              )
                                                            : SizedBox())
                                                        : SizedBox(),
                                                    Text(
                                                      "Kelgan kuni:${students[i]['startedDay']}",
                                                      style:
                                                          appBarStyle.copyWith(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                    )
                                                  ],
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [

                                                InkWell(
                                                  onTap: () {
                                                    if (checkStatus(
                                                            students[i]
                                                                ['studyDays'],
                                                            studentController
                                                                .selectedStudyDate
                                                                .value,
                                                            widget.groupId) ==
                                                        'true') {
                                                      studentController
                                                          .removeStudyDay(
                                                              students[i]['id'],
                                                              widget.groupId,
                                                              students[i]
                                                                  ['uniqueId'],
                                                              {
                                                                'hasReason':
                                                                    false,

                                                              },
                                                              true);
                                                    } else {
                                                      studentController
                                                          .setStudyDay(
                                                              students[i]['id'],
                                                              widget.groupId,
                                                              students[i]
                                                                  ['uniqueId'],
                                                              {
                                                                'hasReason':
                                                                    false,

                                                              },
                                                              true,
                                                              widget.subject);
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.green.withOpacity(checkStatus(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        studentController
                                                                            .selectedStudyDate
                                                                            .value,
                                                                        widget
                                                                            .groupId) !=
                                                                    'true' ||
                                                                checkStatus(
                                                                        students[i]
                                                                            [
                                                                            'studyDays'],
                                                                        studentController
                                                                            .selectedStudyDate
                                                                            .value,
                                                                        widget
                                                                            .groupId) ==
                                                                    'notGiven'
                                                            ? .1
                                                            : 1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8,
                                                            horizontal: 16),
                                                    child: Text(
                                                      'Bor',
                                                      style: TextStyle(
                                                          color: checkStatus(
                                                                          students[i][
                                                                              'studyDays'],
                                                                          studentController
                                                                              .selectedStudyDate
                                                                              .value,
                                                                          widget
                                                                              .groupId) !=
                                                                      'true' ||
                                                                  checkStatus(
                                                                          students[i]
                                                                              [
                                                                              'studyDays'],
                                                                          studentController
                                                                              .selectedStudyDate
                                                                              .value,
                                                                          widget
                                                                              .groupId) ==
                                                                      'notGiven'
                                                              ? Colors.green
                                                              : Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    if (checkStatus(
                                                            students[i]
                                                                ['studyDays'],
                                                            studentController
                                                                .selectedStudyDate
                                                                .value,
                                                            widget.groupId) ==
                                                        'false') {
                                                      studentController
                                                          .removeStudyDay(
                                                              students[i]['id'],
                                                              widget.groupId,
                                                              students[i]
                                                                  ['uniqueId'],
                                                              {
                                                                'hasReason':
                                                                    false,

                                                              },
                                                              true);
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Dialog(
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0)),
                                                            //this right here
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(16),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                              width: Get.width -
                                                                  64,
                                                              height:
                                                                 150,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [

                                                                  Obx(() => Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child: InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                studentController.selectedAbsenseReason.value = "Sababli";
                                                                              },
                                                                              child:
                                                                                  Container(
                                                                                decoration: BoxDecoration(color: studentController.selectedAbsenseReason.value == "Sababli" ? Colors.red : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black)),
                                                                                child: Text(
                                                                                  "Sababli",
                                                                                  style: TextStyle(
                                                                                    color: studentController.selectedAbsenseReason.value == "Sababli" ? Colors.white : Colors.black,
                                                                                  ),
                                                                                ),
                                                                                padding: EdgeInsets.all(8),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                8,
                                                                          ),
                                                                          Expanded(
                                                                            child: InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                studentController.selectedAbsenseReason.value = "Sababsiz";
                                                                              },
                                                                              child:
                                                                                  Container(
                                                                                decoration: BoxDecoration(color: studentController.selectedAbsenseReason.value == "Sababsiz" ? Colors.red : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black)),
                                                                                child: Text(
                                                                                  "Sababsiz",
                                                                                  style: TextStyle(
                                                                                    color: studentController.selectedAbsenseReason.value == "Sababsiz" ? Colors.white : Colors.black,
                                                                                  ),
                                                                                ),
                                                                                padding: EdgeInsets.all(8),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (studentController
                                                                              .reasonOfBeingAbsent
                                                                              .text
                                                                              .isEmpty &&
                                                                          studentController
                                                                              .selectedAbsenseReason
                                                                              .value
                                                                              .isEmpty) {
                                                                        Get.back();
                                                                      } else {
                                                                        studentController.setStudyDay(
                                                                            students[i]['id'],
                                                                            widget.groupId,
                                                                            students[i]['uniqueId'],
                                                                            {
                                                                              'hasReason': studentController.selectedAbsenseReason.value == "Sababli" ? true : false,
                                                                             },
                                                                            false,
                                                                            widget.subject);

                                                                        Get.back();
                                                                      }
                                                                    },
                                                                    child:   CustomButton(
                                                                        color: Colors
                                                                            .red,
                                                                        isLoading: false,
                                                                        text: 'confirm'
                                                                            .tr
                                                                            .capitalizeFirst!),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                  child: Stack(
                                                  alignment:Alignment.topRight,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.red.withOpacity(
                                                                checkStatus(
                                                                            students[i]
                                                                                [
                                                                                'studyDays'],
                                                                            studentController
                                                                                .selectedStudyDate
                                                                                .value,
                                                                            widget
                                                                                .groupId) ==
                                                                        'notChecked' ||
                                                                    checkStatus(
                                                                            students[i]
                                                                                [
                                                                                'studyDays'],
                                                                            studentController
                                                                                .selectedStudyDate
                                                                                .value,
                                                                            widget
                                                                                .groupId) ==
                                                                        'true'
                                                                ? .1
                                                                : 1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(4)),
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 8,
                                                                horizontal: 16),
                                                        child: Text(
                                                          "Yo'q",
                                                          style: TextStyle(
                                                              color: checkStatus(
                                                                              students[i][
                                                                                  'studyDays'],
                                                                              studentController
                                                                                  .selectedStudyDate
                                                                                  .value,
                                                                              widget
                                                                                  .groupId) ==
                                                                          'notChecked' ||
                                                                      checkStatus(
                                                                              students[i]
                                                                                  [
                                                                                  'studyDays'],
                                                                              studentController
                                                                                  .selectedStudyDate
                                                                                  .value,
                                                                              widget
                                                                                  .groupId) ==
                                                                          'true'
                                                                  ? Colors.red
                                                                  : Colors.white,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.w900),
                                                        ),
                                                      ),
                                                      getReason(
                                                          students[i]
                                                          ['studyDays'],
                                                          studentController
                                                              .selectedStudyDate
                                                              .value,
                                                          widget.groupId) == "Sababli" ?      Icon(Icons.star,color:CupertinoColors.systemYellow,):SizedBox()
                                                    ],
                                                  ),
                                                ),

                                                // TextButton(
                                                //   onPressed: () {
                                                //     studentController
                                                //         .setStudyDay(
                                                //             students[i].id,
                                                //             groupId,
                                                //             students[i]
                                                //
                                                //                 ['uniqueId'],
                                                //             {
                                                //           'hasReason': false,
                                                //           'commentary': ""
                                                //         });
                                                //   },
                                                //   child: Text(
                                                //     checkStatus(
                                                //       students[i]['items']
                                                //           ['studyDays'],
                                                //     )
                                                //         ? 'Present'
                                                //         : "Absent",
                                                //     style: TextStyle(
                                                //         fontSize: 12,
                                                //         fontWeight:
                                                //             FontWeight.w900,
                                                //         color: checkStatus(
                                                //           students[i]['items']
                                                //               ['studyDays'],
                                                //         )
                                                //             ? greenColor
                                                //             : Colors.red),
                                                //   ),
                                                // ),

                                                // Visibility(
                                                //   visible: hasDebt(students[i]['items']
                                                //   ['payments']),
                                                //   child: Container(
                                                //     padding: EdgeInsets.all(16),
                                                //     decoration: BoxDecoration(
                                                //         color: Colors.red,
                                                //         border: Border.all(color: Colors.red,width: 1),
                                                //         borderRadius: BorderRadius.circular(102)
                                                //     ),
                                                //     child: Text("Fee unpaid",style: appBarStyle.copyWith(color: Colors.white,fontSize: 16),),
                                                //   ),
                                                // ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ))
                        : Container(
                            alignment: Alignment.center,
                            height: Get.height * .8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/empty.png',
                                  width: 150,
                                ),
                                Text(
                                  'This group has not any students ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          );
                  }
                  // If no data available

                  else {
                    return Text('No data'); // No data available
                  }
                }),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 66,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () async {
                  if (selectedStudents.isEmpty) {
                    Get.snackbar(
                      'Xatolik', // Title
                      'Talabalar tanlanmadi', // Message
                      snackPosition: SnackPosition.TOP,
                      // Position of the snackbar
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      borderRadius: 8,
                      margin: EdgeInsets.all(10),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          insetPadding: EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          //this right here
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            width: Get.width,
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Rostdanham shu raqamlarga sms yuborilsinmi ?',
                                      style: appBarStyle.copyWith(fontSize: 16),
                                      textAlign: TextAlign.center,

                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        groupController.setSmsDate(widget.groupDocId);

                                        Attendance.messageLoader.value = true;
                                        for (int i = 0;
                                            i < selectedStudents.length;
                                            i++) {
                                          if (checkStatus(
                                                  selectedStudents[i]
                                                      ['studyDays'],
                                                  studentController
                                                      .selectedStudyDate.value,
                                                  widget.groupId) ==
                                              'false' && getReason(
                                              students[i]
                                              ['studyDays'],
                                              studentController
                                                  .selectedStudyDate
                                                  .value,
                                              widget.groupId) == "Sababsiz") {
                                            if (await Permission
                                                    .sms.isGranted &&
                                                selectedStudents[i]['phone']
                                                    .toString()
                                                    .isNotEmpty) {
                                              _smsService.sendSMS(
                                                  selectedStudents[i]['phone'],
                                                  setName(
                                                      selectedStudents[i]
                                                          ['name'],
                                                      selectedStudents[i]
                                                          ['surname']));
                                            }
                                          } else {
                                            print('Sms yuborilmadi');
                                          }

                                        }

                                        Attendance.messageLoader.value = false;
                                        selectedStudents.clear();
                                        isStudentChoosen.value = false;

                                        Get.snackbar(
                                          'Xabar', // Title
                                          'Xabar yuborildi',
                                          // Message
                                          snackPosition: SnackPosition.BOTTOM,
                                          // Position of the snackbar
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          borderRadius: 8,
                                          margin: EdgeInsets.all(10),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Tasdiqlash'.tr.capitalizeFirst!,
                                        style: appBarStyle.copyWith(
                                            color: Colors.green),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: Get.back,
                                        child: Text(
                                          'Bekor',
                                          style: appBarStyle.copyWith(
                                              color: Colors.red),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                child: Obx(() => CustomButton(
                      color: Colors.green,
                      text: Attendance.messageLoader.value
                          ? "Yuborilyapti ..."
                          : 'Davomati'.tr.capitalizeFirst!,
                    )),
              )),
              // box.read('isLogged') == '0094'
              //     ? Expanded(
              //         child: InkWell(
              //         onTap: () async {
              //           if (selectedStudents.isEmpty) {
              //             Get.snackbar(
              //               'Xatolik', // Title
              //               'Talabalar tanlanmadi', // Message
              //               snackPosition: SnackPosition.TOP,
              //               // Position of the snackbar
              //               backgroundColor: Colors.red,
              //               colorText: Colors.white,
              //               borderRadius: 8,
              //               margin: EdgeInsets.all(10),
              //             );
              //           } else {
              //             showDialog(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return Dialog(
              //                   backgroundColor: Colors.white,
              //                   insetPadding:
              //                       EdgeInsets.symmetric(horizontal: 16),
              //                   shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(12.0)),
              //                   //this right here
              //                   child: Container(
              //                     padding: EdgeInsets.all(16),
              //                     decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         borderRadius: BorderRadius.circular(12)),
              //                     width: Get.width,
              //                     height: 180,
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.center,
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Column(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.center,
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.center,
              //                           children: [
              //                             SizedBox(
              //                               height: 16,
              //                             ),
              //                             Text(
              //                               'Rostdanham shu raqamlarga sms yuborilsinmi ?',
              //                               style: appBarStyle.copyWith(
              //                                   fontSize: 12),
              //                               textAlign: TextAlign.center,
              //                             ),
              //                             SizedBox(
              //                               height: 16,
              //                             ),
              //                           ],
              //                         ),
              //                         Row(
              //                           mainAxisAlignment:
              //                               MainAxisAlignment.spaceEvenly,
              //                           children: [
              //                             TextButton(
              //                               onPressed: () async {
              //                                 Get.back();
              //                                 messageLoader2.value = true;
              //
              //                                 for (int i = 0;
              //                                     i < selectedStudents.length;
              //                                     i++) {
              //                                   if (selectedStudents[i][
              //                                               'isFreeOfcharge'] ==
              //                                           false &&
              //                                       hasDebtFromMonth(
              //                                           selectedStudents[i]
              //                                               ['payments'],
              //                                           convertDateToMonthYear(
              //                                               studentController
              //                                                   .selectedStudyDate
              //                                                   .value))) {
              //                                     if (await Permission
              //                                             .sms.isGranted &&
              //                                         selectedStudents[i]
              //                                                 ['phone']
              //                                             .toString()
              //                                             .isNotEmpty) {
              //                                       _smsService.sendSMS(
              //                                           selectedStudents[i]
              //                                               ['phone'],
              //                                           "Hurmatli ota-ona, "
              //                                           "\nFarzandingiz ${selectedStudents[i]['surname'].toString().capitalizeFirst} ${selectedStudents[i]['name'].toString().capitalizeFirst!}ning ${getCurrentMonthInUzbek()} oylari uchun to'lovi oyning 5-sanasiga qadar to'lanishi kerak.");
              //
              //                                       _smsService.sendSMS(
              //                                           selectedStudents[i]
              //                                               ['phone'],
              //                                           " Iltimos, to'lovni belgilangan muddatda amalga oshirishingizni so'raymiz.\nHurmat bilan Leader Acadey");
              //                                     }
              //                                   }
              //                                 }
              //
              //                                 messageLoader2.value = false;
              //                                 selectedStudents.clear();
              //                                 isStudentChoosen.value = false;
              //
              //                                 Get.snackbar(
              //                                   'Message', // Title
              //                                   'Your message has been sent',
              //                                   // Message
              //                                   snackPosition:
              //                                       SnackPosition.BOTTOM,
              //                                   // Position of the snackbar
              //                                   backgroundColor: Colors.green,
              //                                   colorText: Colors.white,
              //                                   borderRadius: 8,
              //                                   margin: EdgeInsets.all(10),
              //                                 );
              //                               },
              //                               child: Text(
              //                                 'Confirm'.tr.capitalizeFirst!,
              //                                 style: appBarStyle.copyWith(
              //                                     color: Colors.green),
              //                               ),
              //                             ),
              //                             TextButton(
              //                                 onPressed: Get.back,
              //                                 child: Text(
              //                                   'Cancel',
              //                                   style: appBarStyle.copyWith(
              //                                       color: Colors.red),
              //                                 )),
              //                           ],
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                 );
              //               },
              //             );
              //           }
              //         },
              //         child: Obx(() => Container(
              //               margin: EdgeInsets.only(left: 4),
              //               child: CustomButton(
              //                 color: Colors.red,
              //                 text: messageLoader2.value
              //                     ? "Sending..."
              //                     : 'Payment',
              //               ),
              //             )),
              //       ))
              //     : SizedBox(),
              // box.read('isLogged') == '0094'
              //     ? Expanded(
              //         child: InkWell(
              //         onTap: () async {
              //           if (selectedStudents.isEmpty) {
              //             Get.snackbar(
              //               'Error', // Title
              //               'Students are not selected', // Message
              //               snackPosition: SnackPosition.TOP,
              //               // Position of the snackbar
              //               backgroundColor: Colors.red,
              //               colorText: Colors.white,
              //               borderRadius: 8,
              //               margin: EdgeInsets.all(10),
              //             );
              //           } else {
              //             showDialog(
              //               context: context,
              //               builder: (BuildContext context) {
              //                 return Dialog(
              //                   backgroundColor: Colors.white,
              //                   insetPadding:
              //                       EdgeInsets.symmetric(horizontal: 16),
              //                   shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(12.0)),
              //                   //this right here
              //                   child: Form(
              //                     key: _formKey,
              //                     child: Container(
              //                       padding: EdgeInsets.all(16),
              //                       decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius:
              //                               BorderRadius.circular(12)),
              //                       width: Get.width,
              //                       height: Get.height / 2.5,
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Column(
              //                             children: [
              //                               SizedBox(
              //                                 height: 16,
              //                               ),
              //                               TextFormField(
              //                                 maxLines: 5,
              //                                 controller: customMessage,
              //                                 maxLength: 80,
              //                                 keyboardType: TextInputType.text,
              //                                 decoration: buildInputDecoratione(
              //                                     'Your message here'
              //                                             .tr
              //                                             .capitalizeFirst! ??
              //                                         ''),
              //                               ),
              //                               SizedBox(
              //                                 height: 16,
              //                               ),
              //                             ],
              //                           ),
              //                           InkWell(
              //                             onTap: () async {
              //                               messageLoader3.value = true;
              //                               if (customMessage.text.isNotEmpty) {
              //                                 for (int i = 0;
              //                                     i < selectedStudents.length;
              //                                     i++) {
              //                                   if (await Permission
              //                                           .sms.isGranted &&
              //                                       selectedStudents[i]['phone']
              //                                           .toString()
              //                                           .isNotEmpty) {
              //                                     _smsService.sendSMS(
              //                                         selectedStudents[i]
              //                                             ['phone'],
              //                                         customMessage.text +
              //                                             "\nHurmat bilan Leader Acadey");
              //                                   }
              //
              //                                   await Future.delayed(
              //                                       Duration(seconds: 1));
              //                                 }
              //                                 messageLoader3.value = false;
              //                                 customMessage.clear();
              //                                 selectedStudents.clear();
              //                                 isStudentChoosen.value = false;
              //
              //                                 Get.back();
              //
              //                                 Get.snackbar(
              //                                   'Message', // Title
              //                                   'Your message has been sent',
              //                                   // Message
              //                                   snackPosition:
              //                                       SnackPosition.BOTTOM,
              //                                   // Position of the snackbar
              //                                   backgroundColor: Colors.blue,
              //                                   colorText: Colors.white,
              //                                   borderRadius: 8,
              //                                   margin: EdgeInsets.all(10),
              //                                 );
              //                               } else {
              //                                 Get.back();
              //                               }
              //                             },
              //                             child: Obx(() => CustomButton(
              //                                 isLoading: studentController
              //                                     .isLoading.value,
              //                                 text: messageLoader3.value
              //                                     ? "Sending. . ."
              //                                     : "Send"
              //                                         .tr
              //                                         .capitalizeFirst!)),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               },
              //             );
              //           }
              //         },
              //         child: Container(
              //           margin: EdgeInsets.only(left: 4),
              //           child: CustomButton(
              //             color: Colors.blue,
              //             text: 'Custom',
              //           ),
              //         ),
              //       ))
              //     : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
