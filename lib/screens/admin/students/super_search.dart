import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leader/screens/admin/students/student_info.dart';

import '../../../constants/custom_widgets/FormFieldDecorator.dart';
import '../../../constants/custom_widgets/emptiness.dart';
import '../../../constants/custom_widgets/student_card.dart';
import '../../../constants/theme.dart';

class SuperSearch extends StatefulWidget {
  final List students;

  SuperSearch({required this.students});

  @override
  State<SuperSearch> createState() => _SuperSearchState();
}

class _SuperSearchState extends State<SuperSearch> {
  TextEditingController _searchController = TextEditingController();

  List _filteredItems = [];

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.students
          .where((item) =>
              item['items']['name']!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item['items']['groups']!.contains(query.toLowerCase()) ||
              item['items']['phone']!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item['items']['surname']!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe8e8e8),
        appBar: AppBar(
          title: Text(
            "Qidirish",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: dashBoardColor,
          toolbarHeight: 64,
          leading: IconButton(
            onPressed: Get.back,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  suffix: InkWell(
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _filteredItems = widget.students;

                      });
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  hintText: "Talabalarni qidirish",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      fontFamily: "Manrope",
                      color: Colors.black.withOpacity(.3)),
                  focusColor: greenColor,
                  fillColor: Color(0xFFfafafa),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffE9E9E9))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: greenColor, width: 2)),
                ),
                onChanged: _filterItems,
              ),
              SizedBox(height: 4),
              Expanded(
                child: _filteredItems.length != 0
                    ? ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(StudentInfo(
                                studentId: _filteredItems[i].id,
                                subject: '',
                              ));
                            },
                            child: StudentCard(
                              item: _filteredItems[i]['items'],
                            ),
                          );
                        })
                    : Emptiness(
                        title:
                            'Our center has not any free of charged student '),
              ),
            ],
          ),
        ));
  }
}
