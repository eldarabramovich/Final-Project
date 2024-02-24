class AssignmentData {
  final String subjectName;
  final String description;
  final String lastData;

  AssignmentData({
    required this.subjectName,
    required this.description,
    required this.lastData,
  });
}

//this array just for view to check how the data will shows at the app

List<AssignmentData> assignment = [
  AssignmentData(
    subjectName: "עברית",
    description: "כתיבת תחביר",
    lastData: "10 מאי",
  ),
  AssignmentData(
    subjectName: "English",
    description: " Q2 P120",
    lastData: "13 מאי",
  )
];
