class Message {
  final String parentId;
  final String teacherId;
  final String className;
  final String message;
  final DateTime timestamp;
  final String senderRole;

  Message({
    required this.parentId,
    required this.teacherId,
    required this.className,
    required this.message,
    required this.timestamp,
    required this.senderRole,
  });

  // Factory constructor to create a Message instance from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      parentId: json['parentId'] as String,
      teacherId: json['teacherId'] as String,
      className: json['className'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp']),
      senderRole: json['senderRole'] as String,
    );
  }

  // Method to convert a Message instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'parentId': parentId,
      'teacherId': teacherId,
      'className': className,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'senderRole': senderRole,
    };
  }
}
