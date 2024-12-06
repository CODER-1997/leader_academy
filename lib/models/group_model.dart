class GroupModel {
  final String name;
  final String uniqueId;
  final String warnedDay;
  final String docId;
  final String smsSentDate;
  final int order;




  GroupModel( {
    required this.name,
    required this.uniqueId,
    required this.order,
    required this.warnedDay,
    required this.docId,
    required this.smsSentDate,


  });

// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uniqueId': uniqueId,
      'order': order,
      'warnedDay': warnedDay,
      'docId': docId,
      'smsSentDate': smsSentDate,


    };
  }
}
