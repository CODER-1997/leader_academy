class StudentModel {
  final String name;
  final String surname;
  final String phone;
   final List payments;
  final List grades;
  final List exams;
  final List studyDays;
  final String uniqueId;
  final String startedDay;
  final bool isDeleted;
   final bool isFreeOfcharge;
  final int orderInGroup;
  final int yeralyFee;
  final String paymentType;
   final List homeWorks;
  final List groups;



  StudentModel( {
    required this.name,
    required this.surname,
    required this.phone,
     required this.payments,
    required this.studyDays,
    required this.uniqueId,
    required this.exams,
    required this.grades,
    required this.startedDay,
    required this.isDeleted,
     required this.isFreeOfcharge,
    required this.orderInGroup,
    required this.yeralyFee,
     required this.paymentType,
    required this.homeWorks,
    required this.groups

  });

// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name.toLowerCase(),
      'surname': surname.toLowerCase(),
      'phone': phone,
       'exams': exams,
      'grades': grades,
      'payments': payments,
      'studyDays': studyDays,
      'uniqueId': uniqueId,
      'startedDay': startedDay,
      'isDeleted': isDeleted,
       'isFreeOfcharge': isFreeOfcharge,
      'orderInGroup': orderInGroup,
      'paymentType': paymentType,
      'yeralyFee': yeralyFee,
      'homeWorks': homeWorks,
       'groups': groups,

    };
  }
}
