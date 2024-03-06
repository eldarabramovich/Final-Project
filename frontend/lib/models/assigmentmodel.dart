class AssignmentData {
  final String classname;
  final String subjectname;
  final String description;
  final String lastDate;

  AssignmentData({
    required this.classname,
    required this.subjectname,
    required this.description,
    required this.lastDate,
  });

  factory AssignmentData.fromFirestore(Map<String, dynamic> data) {
    return AssignmentData(
        classname: data['classname'],
        subjectname: data['subjectname'],
        description: data['description'],
        lastDate: data['lastdate']);
  }
}

List<AssignmentData> assignment = [
  AssignmentData(
    classname: "א'1",
    subjectname: "עברית",
    description: "כתיבת תחביר",
    lastDate: "10 מאי",
  ),
];
