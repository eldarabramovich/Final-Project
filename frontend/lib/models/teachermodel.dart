class Teacher {
  final String fullname;
  final String classname;
  final String subject;

  Teacher(
      {required this.fullname, required this.classname, required this.subject});

  factory Teacher.fromFirestore(Map<String, dynamic> data) {
    return Teacher(
      fullname: data['fullanem'],
      classname: data['classname'],
      subject: data['subject'],
    );
  }
}
