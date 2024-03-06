class Student {
  final String id;
  final String fullname;
  final String classname;
  final String email;
  // Add other properties as needed

  Student({
    required this.id,
    required this.fullname,
    required this.classname,
    required this.email,
  });

  // A method to deserialize a Firestore document to a Student object
  factory Student.fromFirestore(Map<String, dynamic> data) {
    return Student(
      id: data['id'],
      fullname: data['fullname'],
      classname: data['name'],
      email: data['email'],
    );
  }
}
