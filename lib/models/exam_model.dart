class ExamModel {
  final String name;
  final String group;
  final String questionNums;
  final String date;
  final bool isCefr;






  ExamModel(  {
    required this.name,
    required this.group,
    required this.questionNums,
    required this.date,
    required this.isCefr,



  });

// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'questionNums': questionNums,
      'date': date,
      'group': group,
      'isCefr': isCefr,

    };
  }
}
