class AssignmentData {
  final String id;
  final String classname;
  final String description;
  final String fileUrl;
  final String lastDate;
  final String subjectname;

  AssignmentData({
    required this.id,
    required this.classname,
    required this.description,
    required this.fileUrl,
    required this.lastDate,
    required this.subjectname,
  });

  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      id: json['id'] ?? '',
      classname: json['classname'] ?? '',
      description: json['description'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      lastDate: json['lastDate'] ?? '',
      subjectname: json['subjectname'] ?? '',
    );
  }
}

