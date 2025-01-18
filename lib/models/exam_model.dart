class ExamModel {
  final String name;
  final String group;
  final String questionNums;
  final String date;
  final bool isTestType;
  final bool isWarned;







  ExamModel(    {
    required this.name,
    required this.group,
    required this.questionNums,
    required this.date,
    required this.isTestType,
    required this.isWarned,



  });

// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'questionNums': questionNums,
      'date': date,
      'group': group,
      'isTestType': isTestType,
      'isWarned': isWarned,

    };
  }
}
