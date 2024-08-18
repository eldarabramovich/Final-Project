class Parent {
  final String id;
  final String fullname;
  final List<Children> children;

  Parent({required this.id, required this.fullname, required this.children});

  factory Parent.fromFirestore(Map<String, dynamic> data) {
    var childrenList = (data['children'] as List<dynamic>?)
            ?.map((childData) =>
                Children.fromFirestore(childData as Map<String, dynamic>))
            .toList() ??
        [];

    return Parent(
      id: data['id'] ?? '',
      fullname: data['fullname'] ?? '',
      children: childrenList,
    );
  }
}

class Children {
  final String id;
  final String fullname;

  Children({required this.id, required this.fullname});

  factory Children.fromFirestore(Map<String, dynamic> data) {
    return Children(
      id: data['id'] ?? '',
      fullname: data['fullname'] ?? '',
    );
  }
}