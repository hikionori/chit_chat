import 'package:chit_chat/app/models/chat.dart';
import 'package:chit_chat/app/models/message.dart';

class LoadedChat {
  final Chat metadata;
  final List<Message> messages;

  LoadedChat({required this.metadata, required this.messages});
}
