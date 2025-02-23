import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:leader/constants/custom_widgets/student_card.dart';
import 'package:leader/constants/text_styles.dart';
import 'package:leader/screens/admin/students/student_payment_history.dart';

class MonthStatistics extends StatefulWidget {
  final String title;
  final List paidStudents;
  final List unpaidStudents;

  MonthStatistics(
      {required this.title,
      required this.paidStudents,
      required this.unpaidStudents});

  @override
  _MonthStatisticsState createState() => _MonthStatisticsState();
}

class _MonthStatisticsState extends State<MonthStatistics>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredItems = widget.unpaidStudents;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.unpaidStudents
          .where((item) =>
              item['items']['name']!
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item['items']['surname']!
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title+"asdasda",
          style: appBarStyle,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Qarzdorlar'),
                  Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(1112)),
                    child: Text(
                      widget.unpaidStudents.length.toString(),
                      style: appBarStyle.copyWith(
                          fontSize: 10, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("To'laganlar"),
                  Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(1211)),
                    child: Text(
                      widget.paidStudents.length.toString(),
                      style: appBarStyle.copyWith(
                          fontSize: 10, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListView(widget.unpaidStudents, false),
          _buildListView(widget.paidStudents, true),
        ],
      ),
    );
  }

  Widget _buildListView(List students, bool isFeePaid) {
    return students.isNotEmpty
        ? Column(
            children: [
              isFeePaid == false
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Qidirish...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: _filterItems,
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: ListView.builder(
                  itemCount: isFeePaid == false
                      ? _filteredItems.length
                      : students.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if (isFeePaid == false) {
                          Get.to(
                              AdminStudentPaymentHistory(
                                date: widget.title,
                              uniqueId: _filteredItems[index]['items']['uniqueId'],
                              id: _filteredItems[index].id,
                              name: _filteredItems[index]['items']['name'],
                              surname: _filteredItems[index]['items']
                                  ['surname'],
                              paidMonths: _filteredItems[index]['items']
                                  ['payments'],
                              yeralyFee: _filteredItems[index]['items']
                                  ['yeralyFee'].toString(),
                              paymentType: _filteredItems[index]['items']
                                  ['paymentType'],
                              subject: 'Matematika'));
                        }
                      },
                      child: StudentCard(
                        item: isFeePaid == false
                            ? _filteredItems[index]['items']
                            : students[index]['items'],
                        isFeePaid: isFeePaid,
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : Center(
            child: Text(
              "Not found",
              style: appBarStyle,
            ),
          );
  }
}
