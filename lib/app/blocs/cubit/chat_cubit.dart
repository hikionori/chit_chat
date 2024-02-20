import 'package:bloc/bloc.dart';
import 'package:chit_chat/app/models/message.dart';
import 'package:chit_chat/app/services/chat_service.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatService chatService = ChatService();
  ChatCubit() : super(ChatInitial());

  void loadChat() {
    emit(ChatLoading());
    // TODO add logic for work with chat
    emit(ChatLoaded(chatId: '123', messages: []));
  }

  void sendMessage(String message) {
    // TODO add logic for send message
  }

  void deleteChat(String chatId) {
    // TODO add logic for delete chat
  }
}
