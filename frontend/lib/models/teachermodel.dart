class Teacher {
  final String fullname;
  final String email;
  final String?
      classHomeroom; // Single class ID where the teacher is a homeroom teacher
  final List<ClassSubject> classesSubject; // List of class subjects

  Teacher({
    required this.fullname,
    required this.email,
    this.classHomeroom,
    required this.classesSubject,
  });

  factory Teacher.fromFirestore(Map<String, dynamic> data) {
    return Teacher(
      fullname: data['fullname'],
      email: data['email'],
      classHomeroom: data['classesHomeroom'],
      classesSubject: List<ClassSubject>.from(
        data['classesSubject']
            .map((classSubject) => ClassSubject.fromMap(classSubject)),
      ),
    );
  }
}

class ClassSubject {
  final String classname;
  final String subject;
  final String subjectId;

  ClassSubject({
    required this.classname,
    required this.subject,
    required this.subjectId,
  });

  factory ClassSubject.fromMap(Map<String, dynamic> data) {
    return ClassSubject(
      classname: data['classname'],
      subject: data['subjectname'],
      subjectId: data['subjectId'],
    );
  }
}
