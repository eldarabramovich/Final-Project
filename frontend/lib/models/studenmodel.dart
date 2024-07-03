class Student {
  final String id;
  final String fullname;
  final String classname;
  final String subClassName;

  Student({
    required this.id,
    required this.fullname,
    required this.classname,
    required this.subClassName,
  });

  factory Student.fromFirestore(Map<String, dynamic> data) {
    return Student(
      id: data['id'] ?? 'unknown',
      fullname: data['fullname'] ?? 'unknown',
      classname: data['classname'] ?? 'unknown',
      subClassName: data['subClassName'] ?? 'unknown',
    );
  }
}
