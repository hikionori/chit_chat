class Chat {
  final String id;
  final String userId;
  final String chatName;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.userId,
    required this.chatName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      userId: json['user_id'],
      chatName: json['chat_name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  String toString() {
    return 'Chat{id: $id, userId: $userId, chatName: $chatName, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
