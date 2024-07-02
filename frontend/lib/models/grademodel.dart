// grademodel.dart

class Grade {
  final String studentId;
  final String studentName;
  final double grade;

  Grade({
    required this.studentId,
    required this.studentName,
    required this.grade,
  });

  factory Grade.fromFirestore(Map<String, dynamic> data) {
    return Grade(
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      grade: data['grade']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'grade': grade,
    };
  }
}
