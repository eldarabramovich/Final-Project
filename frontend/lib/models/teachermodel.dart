class Teacher {
  final String fullname;
  final String email;
  final List<ClassSubject> classes;

  Teacher({required this.fullname, required this.email, required this.classes});
  factory Teacher.fromFirestore(Map<String, dynamic> data) {
    return Teacher(
      fullname: data['fullname'],
      email: data['email'],
      classes: List<ClassSubject>.from(data['classes']
          .map((classSubject) => ClassSubject.fromMap(classSubject))),
    );
  }
}

class ClassSubject {
  final String classname;
  final String subject;

  ClassSubject({required this.classname, required this.subject});

  factory ClassSubject.fromMap(Map<String, dynamic> data) {
    return ClassSubject(
      classname: data['classname'],
      subject: data['subject'],
    );
  }
}
