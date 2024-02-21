class Message {
  final String role; // system, user, assistant
  final String content;

  Message({required this.role, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };

  @override
  String toString() {
    return 'Message{role: $role, content: $content}';
  }
}
