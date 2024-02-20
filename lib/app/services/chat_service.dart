import 'package:chit_chat/app/models/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final User? user = Supabase.instance.client.auth.currentUser;

  Future<void> loadChat() async {
    // TODO add logic for work with chat
  }

  Future<Message> sendMessage(String message) async {
    // TODO add logic for send message
    throw UnimplementedError();
  }

  Future<void> deleteChat(String chatId) async {
    // TODO add logic for delete chat
  }

  Future<void> sendFile(String filePath) async {
    // TODO add logic for send file
  }
}
