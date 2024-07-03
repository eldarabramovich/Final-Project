class Teacher {
  final String fullname;
  final String email;
  final List<ClassSubject> classesHomeroom;
  final List<ClassSubject> classesSubject;

  Teacher({
    required this.fullname,
    required this.email,
    required this.classesHomeroom,
    required this.classesSubject,
  });

  factory Teacher.fromFirestore(Map<String, dynamic> data) {
    return Teacher(
      fullname: data['fullname'],
      email: data['email'],
      classesHomeroom: data['classesHomeroom'] != null
          ? List<ClassSubject>.from(data['classesHomeroom']
              .map((classSubject) => ClassSubject.fromMap(classSubject)))
          : [],
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


