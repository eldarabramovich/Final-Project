class AssignmentData {
  final String id;
  final String subjectname;
  final String classname;
  final String description;
  final String fileUrl;
  final String lastDate;

  AssignmentData({
    required this.id,
    required this.subjectname,
    required this.classname,
    required this.description,
    required this.fileUrl,
    required this.lastDate,
  });

  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      id: json['id'] ?? '',
      subjectname: json['subjectname'] ?? '',
      classname: json['classname'] ?? '',
      description: json['description'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      lastDate: json['lastDate'] ?? '',
    );
  }
}
