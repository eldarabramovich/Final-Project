class Student {
  final String id;
  final String fullname;
  final String classname;
  // Add other properties as needed

  Student({
    required this.id,
    required this.fullname,
    required this.classname,
  });

  // A method to deserialize a Firestore document to a Student object
  factory Student.fromFirestore(Map<String, dynamic> data) {
    return Student(
      id: data['id'] ?? 'unknown',
      fullname: data['fullname'] ?? 'unknown',
      classname: data['classname'] ?? 'unknown',
    );
  }
}
