class Teacher {
  final String fullname;
  final String email;
  final List<String> classHomeroom;
  final List<ClassSubject> classesSubject;

  Teacher({
    required this.fullname,
    required this.email,
    required this.classHomeroom,
    required this.classesSubject,
  });

  factory Teacher.fromFirestore(Map<String, dynamic> data) {
    List<String> classHomeroom = [];
    if (data['classHomeroom'] != null) {
      if (data['classHomeroom'] is List) {
        classHomeroom = List<String>.from(data['classHomeroom']);
      } else if (data['classHomeroom'] is String) {
        classHomeroom = [data['classHomeroom']];
      }
    }

    return Teacher(
      fullname: data['fullname'],
      email: data['email'],
      classHomeroom: classHomeroom,
      classesSubject: data['classesSubject'] != null
          ? List<ClassSubject>.from(data['classesSubject']
              .map((classSubject) => ClassSubject.fromMap(classSubject)))
          : [],
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
