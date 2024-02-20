import 'dart:io';

import 'package:chit_chat/app/models/chat.dart';
import 'package:chit_chat/app/models/loaded_chat.dart';
import 'package:chit_chat/app/models/message.dart';
import 'package:chit_chat/app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  final User? user = Supabase.instance.client.auth.currentUser;
  final supabaseClient = Supabase.instance.client;

  Future<List<Chat>> getChats() async {
    final response =
        await supabaseClient.from('chats').select("*").eq('user_id', user!.id);

    if (response.isEmpty) {
      return [];
    }

    return response.map((e) => Chat.fromJson(e)).toList();
  }

  Future<String> createChat(String chatName) async {
    final response = await supabaseClient.from('chats').insert({
      'user_id': user!.id,
      'chat_name': chatName,
    });

    // get chat id from table by chat name
    final chatId = await supabaseClient
        .from('chats')
        .select('*')
        .eq('chat_name', chatName)
        .single();

    final chat = Chat.fromJson(chatId);
    return chat.id;
  }

  Future<LoadedChat> loadChat(String id) async {
    final metadata =
        await supabaseClient.from('chats').select('*').eq('id', id).single();
    final messages = await supabaseClient
        .from('chat_messages')
        .select('*')
        .eq('chat_id', id)
        .order('created_at', ascending: true);

    final chat = Chat.fromJson(metadata);
    final chatMessages = messages.map((e) => Message.fromJson(e)).toList();

    return LoadedChat(metadata: chat, messages: chatMessages);
  }

  // TODO add logic for generate chat name by message
  Future<void> sendMessage(String message, String? chatId) async {
    if (chatId == null) {
      // create new chat and send message to it
      final chatId = await createChat("New chat2");
      final response = await supabaseClient.from("chat_messages").insert({
        "chat_id": chatId,
        "role": "user",
        "message": message,
      });
    }

    final response = await supabaseClient.from("chat_messages").insert({
      "chat_id": chatId,
      "role": "user",
      "message": message,
    });
  }

  Future<void> deleteChat(String chatId) async {
    await supabaseClient.from('chats').delete().eq('id', chatId);
  }

  Future<void> sendFile(String filePath) async {
    var file =
        File("/home/hikionori/Documents/Projects/chit_chat/pubspec.yaml");
    var response = await supabaseClient.storage
        .from("test_files")
        .upload("${DateTime.now().millisecondsSinceEpoch}.yaml", file);
    print(response);
    // get id from objects
    var id = await supabaseClient
        .from("objects_vie")
        .select("*")
        .eq("name", response.split("/").last);
    print(id);
  }
}
