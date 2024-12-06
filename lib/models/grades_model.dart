class GradeModel {

  final String date;
  final String time;
  final String group;
  final String uniqueId;






  GradeModel(  {
    required this.time,
    required this.date,
    required this.group,
    required this.uniqueId,



  });

// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {

      'date': date,
      'time': time,
      'group': group,
      'uniqueId': uniqueId,

    };
  }
}
