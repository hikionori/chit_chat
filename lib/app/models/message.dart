class Message {
  final String id;
  final String chatId;
  final String text;
  final String sender;
  final List embedding;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.chatId,
    required this.text,
    required this.sender,
    required this.embedding,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      text: json['message'],
      sender: json['role'],
      embedding: json['embedding'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
